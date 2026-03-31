#ifdef SHOULD_COMPILE_LOOKIN_SERVER

#import <Foundation/Foundation.h>

@class LKS_HTTPRequest, LKS_HTTPResponse;

typedef void (^LKS_HTTPCompletionBlock)(LKS_HTTPResponse *response);
typedef void (^LKS_HTTPRequestHandler)(LKS_HTTPRequest *request, LKS_HTTPCompletionBlock completion);

// ──────────────────────────────────────────────
#pragma mark - LKS_HTTPRequest

@interface LKS_HTTPRequest : NSObject

@property(nonatomic, copy) NSString *method;
@property(nonatomic, copy) NSString *path;
@property(nonatomic, strong) NSDictionary *jsonBody;
/// 从路径 /view/:oid/... 中提取的 oid，不存在则为 0
@property(nonatomic, assign) unsigned long oidParam;

@end

// ──────────────────────────────────────────────
#pragma mark - LKS_HTTPResponse

@interface LKS_HTTPResponse : NSObject

@property(nonatomic, assign) NSInteger statusCode;
@property(nonatomic, strong) NSDictionary *jsonBody;

+ (instancetype)okWithData:(nullable id)data;
+ (instancetype)errorWithMessage:(NSString *)message statusCode:(NSInteger)statusCode;

@end

// ──────────────────────────────────────────────
#pragma mark - LKS_HTTPServer

@interface LKS_HTTPServer : NSObject

@property(nonatomic, copy) LKS_HTTPRequestHandler requestHandler;
@property(nonatomic, assign, readonly) BOOL isRunning;
@property(nonatomic, assign, readonly) uint16_t port;

- (BOOL)startWithPort:(uint16_t)port error:(NSError **)outError;
- (void)stop;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
