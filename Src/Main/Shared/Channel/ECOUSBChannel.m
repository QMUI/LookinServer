//
//  ECOUSBChannel.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOUSBChannel.h"
#import "Lookin_PTChannel.h"
#import "ECOChannelDeviceInfo.h"

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#endif

static const int ECOUSBChannelIPv4PortNumber = 2333;
static const NSTimeInterval ECOUSBChannelReconnectDelay = 1.0;

@interface ECOUSBChannel()
<Lookin_PTChannelDelegate> {
    dispatch_queue_t _notConnectedQueue;
}

@property (nonatomic, weak) Lookin_PTChannel *serverChannel;
@property (nonatomic, weak) Lookin_PTChannel *peerChannel;

@property (nonatomic, strong) NSNumber *connectingToDeviceID;
@property (nonatomic, strong) NSNumber *connectedDeviceID;
@property (nonatomic, strong) NSDictionary *connectedDeviceProperties;
@property (nonatomic, strong) Lookin_PTChannel *connectedChannel;

@end

@implementation ECOUSBChannel

#pragma mark - LifeCycle methods
- (void)dealloc {
    NSLog(@"%s",__func__);
    if (self.serverChannel) {
        [self.serverChannel close];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//初始化
- (void)setupChannel {
    [super setupChannel];
    self.priority = ECOChannelPriority_USB;
    
#if TARGET_OS_OSX
    _notConnectedQueue = dispatch_queue_create("com.echo.notConnectedQueue", DISPATCH_QUEUE_SERIAL);
    // Start listening for device attached/detached notifications
    [self startListeningForDevices];
    // Start trying to connect to local IPv4 port (defined in PTExampleProtocol.h)
    [self enqueueConnectToLocalIPv4Port];

    [self ping];
#else
    [self setupPTChannel];
#endif
}
//是否有usb连接
- (BOOL)isConnected {
#if TARGET_OS_OSX
    return self.connectedDeviceID != nil;
#else
    return self.peerChannel != nil;
#endif
}
//创建channel
- (void)setupPTChannel {
	Lookin_PTChannel *channel = [Lookin_PTChannel channelWithDelegate:self];
    [channel listenOnPort:ECOUSBChannelIPv4PortNumber IPv4Address:INADDR_LOOPBACK callback:^(NSError *error) {
        if (error) {
            NSLog(@">> [ECOUSBChannel] Failed to listen on 127.0.0.1:%d: %@", ECOUSBChannelIPv4PortNumber, error);
        }else{
            NSLog(@">> [ECOUSBChannel] Listening on 127.0.0.1:%d", ECOUSBChannelIPv4PortNumber);
            self.serverChannel = channel;
        }
    }];
}

#pragma mark - Wired device connections
- (void)startListeningForDevices {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onUSBDeviceDidAttach:) name:Lookin_PTUSBDeviceDidAttachNotification object:Lookin_PTUSBHub.sharedHub];
    [center addObserver:self selector:@selector(onUSBDeviceDidDetach:) name:Lookin_PTUSBDeviceDidDetachNotification object:Lookin_PTUSBHub.sharedHub];
}
- (void)onUSBDeviceDidAttach:(NSNotification *)note {
    NSNumber *deviceID = [note.userInfo objectForKey:@"DeviceID"];
    NSLog(@"<< [ECOUSBChannel] PTUSBDeviceDidAttachNotification:%@", deviceID);
    //    [self showAlertWithMessage:[NSString stringWithFormat:@"usb设备连接:%@",deviceID]];
    
    dispatch_async(_notConnectedQueue, ^{
        if (!self.connectingToDeviceID ||
            ![deviceID isEqualToNumber:self.connectingToDeviceID]) {
            [self disconnectFromCurrentChannel];
            self.connectingToDeviceID = deviceID;
            self.connectedDeviceProperties = [note.userInfo objectForKey:@"Properties"];
            [self enqueueConnectToUSBDevice];
        }
    });
}
- (void)onUSBDeviceDidDetach:(NSNotification *)note {
    NSNumber *deviceID = [note.userInfo objectForKey:@"DeviceID"];
    NSLog(@"<< [ECOUSBChannel] PTUSBDeviceDidDetachNotification:%@", deviceID);
    //    [self showAlertWithMessage:[NSString stringWithFormat:@"usb设备断开:%@",deviceID]];
    
    if ([self.connectingToDeviceID isEqualToNumber:deviceID]) {
        self.connectedDeviceProperties = nil;
        self.connectingToDeviceID = nil;
        if (self.connectedChannel) {
            [self.connectedChannel close];
        }
    }
}

- (void)enqueueConnectToLocalIPv4Port {
    dispatch_async(_notConnectedQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectToLocalIPv4Port];
        });
    });
}

- (void)connectToLocalIPv4Port {
	Lookin_PTChannel *channel = [Lookin_PTChannel channelWithDelegate:self];
    channel.userInfo = [NSString stringWithFormat:@"127.0.0.1:%d", ECOUSBChannelIPv4PortNumber];
    [channel connectToPort:ECOUSBChannelIPv4PortNumber IPv4Address:INADDR_LOOPBACK callback:^(NSError *error, Lookin_PTAddress *address) {
        if (error) {
            if (error.domain == NSPOSIXErrorDomain && (error.code == ECONNREFUSED || error.code == ETIMEDOUT)) {
                // this is an expected state
            }else{
                NSLog(@"<< [ECOUSBChannel] Failed to connect to 127.0.0.1:%d: %@", ECOUSBChannelIPv4PortNumber, error);
            }
            [self performSelector:@selector(enqueueConnectToLocalIPv4Port) withObject:nil afterDelay:ECOUSBChannelReconnectDelay];
        }else{
            [self disconnectFromCurrentChannel];
            self.connectedChannel = channel;
            channel.userInfo = address;
            NSLog(@"<< [ECOUSBChannel] Connected to %@", address);
        }
    }];
}

- (void)enqueueConnectToUSBDevice {
    dispatch_async(_notConnectedQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectToUSBDevice];
        });
    });
}

- (void)connectToUSBDevice {
	Lookin_PTChannel *channel = [Lookin_PTChannel channelWithDelegate:self];
    channel.userInfo = self.connectingToDeviceID;
    channel.delegate = self;
    [channel connectToPort:ECOUSBChannelIPv4PortNumber overUSBHub:Lookin_PTUSBHub.sharedHub deviceID:self.connectingToDeviceID callback:^(NSError *error) {
        if (error) {
            if (error.domain == Lookin_PTUSBHubErrorDomain && error.code == PTUSBHubErrorConnectionRefused) {
                //                NSLog(@"<< [ECOUSBChannel] Failed to connect to device #%@: %@", channel.userInfo, error);
            }else{
                //                NSLog(@"<< [ECOUSBChannel] Failed to connect to device #%@: %@", channel.userInfo, error);
            }
            if (channel.userInfo == self.connectingToDeviceID) {
                //重试连接
                [self performSelector:@selector(enqueueConnectToUSBDevice) withObject:nil afterDelay:ECOUSBChannelReconnectDelay];
            }
        }else{
            self.connectedDeviceID = self.connectingToDeviceID;
            self.connectedChannel = channel;
            NSLog(@"<< [ECOUSBChannel] Connect to device #%@\n%@", channel.userInfo, self.connectedDeviceProperties);
            //发送ping信息
            [self ping];
        }
    }];
}

- (void)disconnectFromCurrentChannel {
    if (self.connectedDeviceID && self.connectedChannel) {
        [self.connectedChannel close];
        self.connectedChannel = nil;
    }
}

- (void)didDisconnectFromDevice:(NSNumber*)deviceID {
    NSLog(@"<< [ECOUSBChannel] Disconnected from device:%@", deviceID);
    if ([self.connectedDeviceID isEqualToNumber:deviceID]) {
        [self willChangeValueForKey:@"connectedDeviceID"];
        self.connectedDeviceID = nil;
        [self didChangeValueForKey:@"connectedDeviceID"];
    }
}

#pragma mark - Send Messages
- (void)ping {
    if (!self.connectedChannel) {
        [self performSelector:@selector(ping) withObject:nil afterDelay:1.f];
        return;
    }
    uint32_t tagno = [self.connectedChannel.protocol newTag];
    ECOChannelDeviceInfo *deviceInfo = [ECOChannelDeviceInfo new];
    dispatch_data_t payload = ECOUSBChannelDispatchDataWithPayload(deviceInfo.ipAddress);
    [self.connectedChannel sendFrameOfType:ECOUSBChannelType_Ping tag:tagno withPayload:payload callback:^(NSError *error) {
        //        [self performSelector:@selector(ping) withObject:nil afterDelay:1.f];
    }];
}
- (void)sendMessage:(NSString *)message {
#if TARGET_OS_OSX
    if (self.connectedChannel) {
        [self.connectedChannel sendFrameOfType:ECOUSBChannelType_TextMessage tag:PTFrameNoTag withPayload:ECOUSBChannelDispatchDataWithPayload(message) callback:^(NSError *error) {
            if (error) {
                NSLog(@">> [ECOUSBChannel] Failed to send message: %@", error);
            }
            NSLog(@">> [ECOUSBChannel] you: %@", message);
        }];
    }
#else
    if (self.peerChannel) {
        [self.peerChannel sendFrameOfType:ECOUSBChannelType_TextMessage tag:PTFrameNoTag withPayload:ECOUSBChannelDispatchDataWithPayload(message) callback:^(NSError *error) {
            if (error) {
                NSLog(@">> [ECOUSBChannel] Failed to send message: %@", error);
            }
            NSLog(@">> [ECOUSBChannel] you: %@", message);
        }];
    }
#endif
}
#pragma mark - dispatch_data_t
static dispatch_data_t ECOUSBChannelDispatchDataWithPayload(id payload) {
    if ([payload isKindOfClass:[NSString class]]) {
        //字符串
        NSString *message = (NSString *)payload;
        const char *utf8text = [message cStringUsingEncoding:NSUTF8StringEncoding];
        size_t length = strlen(utf8text);
        ECOUSBChannelTextFrame *textFrame = CFAllocatorAllocate(nil, sizeof(ECOUSBChannelTextFrame) + length, 0);
        memcpy(textFrame->utf8text, utf8text, length);
        textFrame->length = htonl(length);
        
        return dispatch_data_create((const void*)textFrame, sizeof(ECOUSBChannelTextFrame) + length, nil, ^{
            CFAllocatorDeallocate(nil, textFrame);
        });
    }else if ([payload isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *info = (NSDictionary *)payload;
        return [info createReferencingDispatchData];
    }
    return nil;
}
#pragma mark - PTChannelDelegate methods
// Invoked to accept an incoming frame on a channel. Reply NO ignore the
// incoming frame. If not implemented by the delegate, all frames are accepted.
- (BOOL)ioFrameChannel:(Lookin_PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
//    NSLog(@"%s",__func__);
#if TARGET_OS_OSX
    if (channel != self.peerChannel) {
        // A previous channel that has been canceled but not yet ended. Ignore.
        return NO;
    }
#endif
    return YES;
}

// Invoked when a new frame has arrived on a channel.
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(Lookin_PTData*)payload {
//    NSLog(@"%s",__func__);
    if (type == ECOUSBChannelType_TextMessage) {
        ECOUSBChannelTextFrame *textFrame = (ECOUSBChannelTextFrame *)payload.data;
        textFrame->length = ntohl(textFrame->length);
        NSString *message = [[NSString alloc] initWithBytes:textFrame->utf8text length:textFrame->length encoding:NSUTF8StringEncoding];
//        NSLog(@">> [ECOUSBChannel] [%@]: %@", channel.userInfo, message);
        // 测试：自动会话
        [self sendMessage:message];
    }else if (type == ECOUSBChannelType_Ping) {
//        NSLog(@">> [ECOUSBChannel] received ping: %@", channel.userInfo);
        ECOUSBChannelTextFrame *textFrame = (ECOUSBChannelTextFrame *)payload.data;
        textFrame->length = ntohl(textFrame->length);
        NSString *ipAddress = [[NSString alloc] initWithBytes:textFrame->utf8text length:textFrame->length encoding:NSUTF8StringEncoding];
//        NSLog(@">> [ECOUSBChannel] [%@]: %@", channel.userInfo, ipAddress);
        !self.attachBlock ?: self.attachBlock(ipAddress);
        
//        if (self.peerChannel) {
//            [self.peerChannel sendFrameOfType:ECOUSBChannelType_Pong tag:tag withPayload:nil callback:nil];
//        }
    }else if (type == ECOUSBChannelType_Pong) {
//        NSLog(@">> [ECOUSBChannel] receive pong: %@", channel.userInfo);
    }
}

// Invoked when the channel closed. If it closed because of an error, *error* is
// a non-nil NSError object.
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didEndWithError:(NSError*)error {
//    NSLog(@"%s",__func__);
    if (error) {
//        NSLog(@">> [ECOUSBChannel] %@ end with error:%@", channel, error);
    }else{
//        NSLog(@">> [ECOUSBChannel] Disconnected from %@", channel.userInfo);
    }
#if TARGET_OS_OSX
    if (self.connectedDeviceID && [self.connectedDeviceID isEqualToNumber:channel.userInfo]) {
        [self didDisconnectFromDevice:self.connectedDeviceID];
    }
    if (self.connectedChannel == channel) {
//        NSLog(@">> [ECOUSBChannel] Disconnected from: %@", channel.userInfo);
        self.connectedChannel = nil;
    }
#endif
}

// For listening channels, this method is invoked when a new connection has been
// accepted.
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didAcceptConnection:(Lookin_PTChannel*)otherChannel fromAddress:(Lookin_PTAddress*)address {
//    NSLog(@"%s",__func__);
    if (self.peerChannel) {
        [self.peerChannel cancel];
    }
    
    self.peerChannel = otherChannel;
    self.peerChannel.userInfo = address;
//    NSLog(@">> [ECOUSBChannel] Connected to %@", address);
    //测试，回复消息
//    [self sendMessage:@"你好"];
}

@end
