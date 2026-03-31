#ifdef SHOULD_COMPILE_LOOKIN_SERVER

#import "LKS_HTTPServer.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

// ──────────────────────────────────────────────
#pragma mark - LKS_HTTPRequest

@implementation LKS_HTTPRequest
@end

// ──────────────────────────────────────────────
#pragma mark - LKS_HTTPResponse

@implementation LKS_HTTPResponse

+ (instancetype)okWithData:(nullable id)data {
    LKS_HTTPResponse *r = [LKS_HTTPResponse new];
    r.statusCode = 200;
    r.jsonBody = @{ @"success": @YES, @"data": data ?: [NSNull null] };
    return r;
}

+ (instancetype)errorWithMessage:(NSString *)message statusCode:(NSInteger)statusCode {
    LKS_HTTPResponse *r = [LKS_HTTPResponse new];
    r.statusCode = statusCode;
    r.jsonBody = @{ @"success": @NO, @"error": message ?: @"Unknown error" };
    return r;
}

@end

// ──────────────────────────────────────────────
#pragma mark - LKS_HTTPServer

@interface LKS_HTTPServer ()
@property(nonatomic, assign) int serverFd;
@property(nonatomic, assign, readwrite) BOOL isRunning;
@property(nonatomic, assign, readwrite) uint16_t port;
@end

@implementation LKS_HTTPServer

- (instancetype)init {
    if (self = [super init]) {
        _serverFd = -1;
    }
    return self;
}

- (BOOL)startWithPort:(uint16_t)port error:(NSError **)outError {
    if (self.isRunning) return YES;

    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        if (outError) *outError = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
        return NO;
    }

    int yes = 1;
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));
    setsockopt(fd, SOL_SOCKET, SO_NOSIGPIPE, &yes, sizeof(yes));

    struct sockaddr_in addr = {};
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons(port);

    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        if (outError) *outError = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
        close(fd);
        return NO;
    }

    if (listen(fd, 8) < 0) {
        if (outError) *outError = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
        close(fd);
        return NO;
    }

    self.serverFd = fd;
    self.port = port;
    self.isRunning = YES;

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self _acceptLoop];
    });

    NSLog(@"LookinServer - HTTP Server started on 127.0.0.1:%d", port);
    return YES;
}

- (void)stop {
    if (!self.isRunning) return;
    self.isRunning = NO;
    if (self.serverFd >= 0) {
        close(self.serverFd);
        self.serverFd = -1;
    }
}

- (void)_acceptLoop {
    while (self.isRunning) {
        struct sockaddr_in clientAddr;
        socklen_t clientAddrLen = sizeof(clientAddr);
        int clientFd = accept(self.serverFd, (struct sockaddr *)&clientAddr, &clientAddrLen);
        if (clientFd < 0) {
            if (!self.isRunning) break;
            continue;
        }
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            [self _handleConnection:clientFd];
        });
    }
}

- (void)_handleConnection:(int)clientFd {
    struct timeval tv = { .tv_sec = 10, .tv_usec = 0 };
    setsockopt(clientFd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));

    NSData *rawData = [self _readFullRequest:clientFd];
    if (!rawData) {
        close(clientFd);
        return;
    }

    LKS_HTTPRequest *request = [self _parseRequest:rawData];
    if (!request) {
        LKS_HTTPResponse *resp = [LKS_HTTPResponse errorWithMessage:@"Bad request" statusCode:400];
        [self _writeResponse:resp toFd:clientFd];
        close(clientFd);
        return;
    }

    // 切换到主线程处理（iOS UI API 需要主线程）
    dispatch_async(dispatch_get_main_queue(), ^{
        LKS_HTTPRequestHandler handler = self.requestHandler;
        if (!handler) {
            LKS_HTTPResponse *resp = [LKS_HTTPResponse errorWithMessage:@"No handler" statusCode:500];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                [self _writeResponse:resp toFd:clientFd];
                close(clientFd);
            });
            return;
        }
        handler(request, ^(LKS_HTTPResponse *response) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                [self _writeResponse:response toFd:clientFd];
                close(clientFd);
            });
        });
    });
}

#pragma mark - HTTP Parsing

- (nullable NSData *)_readFullRequest:(int)fd {
    NSMutableData *data = [NSMutableData data];
    char buf[8192];

    while (YES) {
        ssize_t n = recv(fd, buf, sizeof(buf), 0);
        if (n <= 0) break;
        [data appendBytes:buf length:(NSUInteger)n];

        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange sep = [str rangeOfString:@"\r\n\r\n"];
        if (sep.location == NSNotFound) continue;

        NSRange headerRange = NSMakeRange(0, sep.location);
        NSString *headers = [str substringWithRange:headerRange];
        NSInteger contentLength = [self _parseContentLength:headers];

        NSInteger bodyStart = (NSInteger)(sep.location + 4);
        NSInteger bodyReceived = (NSInteger)data.length - bodyStart;
        if (contentLength <= 0 || bodyReceived >= contentLength) break;
    }
    return data.length > 0 ? data : nil;
}

- (NSInteger)_parseContentLength:(NSString *)headers {
    for (NSString *line in [headers componentsSeparatedByString:@"\r\n"]) {
        if ([line.lowercaseString hasPrefix:@"content-length:"]) {
            NSString *value = [[line substringFromIndex:15] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            return value.integerValue;
        }
    }
    return 0;
}

- (nullable LKS_HTTPRequest *)_parseRequest:(NSData *)data {
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!str) return nil;

    NSRange sep = [str rangeOfString:@"\r\n\r\n"];
    NSString *headerPart = sep.location != NSNotFound ? [str substringToIndex:sep.location] : str;
    NSArray<NSString *> *headerLines = [headerPart componentsSeparatedByString:@"\r\n"];
    if (headerLines.count == 0) return nil;

    NSArray<NSString *> *requestLineParts = [headerLines[0] componentsSeparatedByString:@" "];
    if (requestLineParts.count < 2) return nil;

    LKS_HTTPRequest *request = [LKS_HTTPRequest new];
    request.method = requestLineParts[0].uppercaseString;

    NSString *fullPath = requestLineParts[1];
    NSRange queryRange = [fullPath rangeOfString:@"?"];
    request.path = queryRange.location != NSNotFound ? [fullPath substringToIndex:queryRange.location] : fullPath;

    if (sep.location != NSNotFound) {
        NSString *bodyStr = [str substringFromIndex:sep.location + 4];
        if (bodyStr.length > 0) {
            NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
            request.jsonBody = [NSJSONSerialization JSONObjectWithData:bodyData options:0 error:nil];
        }
    }

    // 提取 /view/:oid/... 中的 oid
    NSArray<NSString *> *pathComponents = [request.path componentsSeparatedByString:@"/"];
    if (pathComponents.count >= 3 && [pathComponents[1] isEqualToString:@"view"]) {
        request.oidParam = (unsigned long)[pathComponents[2] longLongValue];
    }

    return request;
}

#pragma mark - HTTP Response Writing

- (void)_writeResponse:(LKS_HTTPResponse *)response toFd:(int)fd {
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:response.jsonBody options:0 error:nil];
    if (!bodyData) {
        bodyData = [@"{\"success\":false,\"error\":\"JSON serialization failed\"}" dataUsingEncoding:NSUTF8StringEncoding];
    }

    NSString *statusText;
    switch (response.statusCode) {
        case 200: statusText = @"OK"; break;
        case 400: statusText = @"Bad Request"; break;
        case 404: statusText = @"Not Found"; break;
        case 500: statusText = @"Internal Server Error"; break;
        case 503: statusText = @"Service Unavailable"; break;
        default:  statusText = @"OK"; break;
    }

    NSString *headerStr = [NSString stringWithFormat:
        @"HTTP/1.1 %ld %@\r\n"
        @"Content-Type: application/json; charset=utf-8\r\n"
        @"Content-Length: %lu\r\n"
        @"Connection: close\r\n"
        @"Access-Control-Allow-Origin: *\r\n"
        @"\r\n",
        (long)response.statusCode, statusText,
        (unsigned long)bodyData.length];

    NSData *headerData = [headerStr dataUsingEncoding:NSUTF8StringEncoding];
    send(fd, headerData.bytes, headerData.length, 0);
    send(fd, bodyData.bytes, bodyData.length, 0);
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
