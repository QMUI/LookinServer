#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2018/8/5.
//  https://lookin.work
//

#import "LKS_ConnectionManager.h"
#import "Lookin_PTChannel.h"
#import "LKS_RequestHandler.h"
#import "LookinConnectionResponseAttachment.h"
#import "LKS_ExportManager.h"
#import "LookinServerDefines.h"
#import "LKS_TraceManager.h"

NSString *const LKS_ConnectionDidEndNotificationName = @"LKS_ConnectionDidEndNotificationName";

@interface LKS_ConnectionManager () <Lookin_PTChannelDelegate>

@property(nonatomic, weak) Lookin_PTChannel *peerChannel_;

@property(nonatomic, strong) LKS_RequestHandler *requestHandler;

@end

@implementation LKS_ConnectionManager

+ (instancetype)sharedInstance {
    static LKS_ConnectionManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LKS_ConnectionManager alloc] init];
    });
    return sharedInstance;
}

+ (void)load {
    // 触发 init 方法
    [LKS_ConnectionManager sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"LookinServer - Will launch. Framework version: %@", LOOKIN_SERVER_READABLE_VERSION);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleLocalInspectIn2D:) name:@"Lookin_2D" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleLocalInspectIn3D:) name:@"Lookin_3D" object:nil];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"Lookin_Export" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [[LKS_ExportManager sharedInstance] exportAndShare];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"Lookin_RelationSearch" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [[LKS_TraceManager sharedInstance] addSearchTarger:note.object];
        }];
        
        self.requestHandler = [LKS_RequestHandler new];
    }
    return self;
}

- (void)_handleWillResignActiveNotification {
    self.applicationIsActive = NO;
}

- (void)_handleApplicationDidBecomeActive {
    self.applicationIsActive = YES;
    [self tryToListenPorts];
}

- (void)tryToListenPorts {
    if (self.peerChannel_) {
        // 除了 connected 和 listenin 状态之外，还可能是 close 状态。如果连接了 client 端，而 client 端又关闭了，那么这里的 channel 就会变成 close
        if ([self.peerChannel_ isConnected] || [self.peerChannel_ isListening]) {
//            NSLog(@"LookinServer - Abort connect trying. Already has active channel.");
            return;
        }
    }
    NSLog(@"LookinServer - Trying to connect ...");
    if ([self isiOSAppOnMac]) {
        [self _tryToListenOnPortFrom:LookinSimulatorIPv4PortNumberStart to:LookinSimulatorIPv4PortNumberEnd current:LookinSimulatorIPv4PortNumberStart];
    } else {
        [self _tryToListenOnPortFrom:LookinUSBDeviceIPv4PortNumberStart to:LookinUSBDeviceIPv4PortNumberEnd current:LookinUSBDeviceIPv4PortNumberStart];
    }
}

- (BOOL)isiOSAppOnMac {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    if (@available(iOS 14.0, *)) {
        return [NSProcessInfo processInfo].isiOSAppOnMac || [NSProcessInfo processInfo].isMacCatalystApp;
    }
    if (@available(iOS 13.0, tvOS 13.0, *)) {
        return [NSProcessInfo processInfo].isMacCatalystApp;
    }
    return NO;
#endif
}

- (void)_tryToListenOnPortFrom:(int)fromPort to:(int)toPort current:(int)currentPort  {
    Lookin_PTChannel *channel = [Lookin_PTChannel channelWithDelegate:self];
    [channel listenOnPort:currentPort IPv4Address:INADDR_LOOPBACK callback:^(NSError *error) {
        if (error) {
            if (error.code == 48) {
                // 该地址已被占用
            } else {
                // 未知失败
            }
            
            if (currentPort < toPort) {
                // 尝试下一个端口
                NSLog(@"LookinServer - 127.0.0.1:%d is unavailable(%@). Will try anothor address ...", currentPort, error);
                [self _tryToListenOnPortFrom:fromPort to:toPort current:(currentPort + 1)];
            } else {
                // 所有端口都尝试完毕，全部失败
                NSLog(@"LookinServer - 127.0.0.1:%d is unavailable(%@).", currentPort, error);
                NSLog(@"LookinServer - Connect failed in the end. Ask for help: lookin@lookin.work");
            }
            
        } else {
            // 成功
            NSLog(@"LookinServer - Connected successfully on 127.0.0.1:%d", currentPort);
            // 此时 peerChannel_ 状态为 listening
            self.peerChannel_ = channel;
        }
    }];
}

- (void)dealloc {
    if (self.peerChannel_) {
        [self.peerChannel_ close];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)isConnected {
    return self.peerChannel_ && self.peerChannel_.isConnected;
}

- (void)respond:(LookinConnectionResponseAttachment *)data requestType:(uint32_t)requestType tag:(uint32_t)tag {
    [self _sendData:data frameOfType:requestType tag:tag];
}

- (void)pushData:(NSObject *)data type:(uint32_t)type {
    [self _sendData:data frameOfType:type tag:0];
}

- (void)_sendData:(NSObject *)data frameOfType:(uint32_t)frameOfType tag:(uint32_t)tag {
    if (self.peerChannel_) {
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
        dispatch_data_t payload = [archivedData createReferencingDispatchData];
        
        [self.peerChannel_ sendFrameOfType:frameOfType tag:tag withPayload:payload callback:^(NSError *error) {
            if (error) {
            }
        }];
    }
}

#pragma mark - Lookin_PTChannelDelegate

- (BOOL)ioFrameChannel:(Lookin_PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    if (channel != self.peerChannel_) {
        return NO;
    } else if ([self.requestHandler canHandleRequestType:type]) {
        return YES;
    } else {
        [channel close];
        return NO;
    }
}

- (void)ioFrameChannel:(Lookin_PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(Lookin_PTData*)payload {
    id object = nil;
    if (payload) {
        id unarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfDispatchData:payload.dispatchData]];
        if ([unarchivedObject isKindOfClass:[LookinConnectionAttachment class]]) {
            LookinConnectionAttachment *attachment = (LookinConnectionAttachment *)unarchivedObject;
            object = attachment.data;
        } else {
            object = unarchivedObject;
        }
    }
    [self.requestHandler handleRequestType:type tag:tag object:object];
}

/// 当连接过 Lookin 客户端，然后 Lookin 客户端又被关闭时，会走到这里
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didEndWithError:(NSError*)error {
//    NSLog(@"LookinServer - didEndWithError:%@", channel);
    [[NSNotificationCenter defaultCenter] postNotificationName:LKS_ConnectionDidEndNotificationName object:self];
    [self tryToListenPorts];
}

/// 当 Client 端链接成功时，该方法会被调用，然后 channel 的状态会变成 connected
- (void)ioFrameChannel:(Lookin_PTChannel*)channel didAcceptConnection:(Lookin_PTChannel*)otherChannel fromAddress:(Lookin_PTAddress*)address {
//    NSLog(@"LookinServer - didAcceptConnection:%@, current:%@", otherChannel, self.peerChannel_);
    Lookin_PTChannel *previousChannel = self.peerChannel_;
    self.peerChannel_ = otherChannel;
    self.peerChannel_.userInfo = address;
    
    if (previousChannel && previousChannel != self.peerChannel_) {
        [previousChannel cancel];
    }
}

#pragma mark - Handler

- (void)_handleLocalInspectIn2D:(NSNotification *)note {
    UIAlertController  *alertController = [UIAlertController  alertControllerWithTitle:@"Lookin" message:@"Failed to run local inspection. The feature has been removed. Please use the computer version of Lookin or consider SDKs like FLEX for similar functionality."  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    UIApplication *app = [UIApplication  sharedApplication];
    UIWindow *keyWindow = [app keyWindow];
    UIViewController *rootViewController = [keyWindow rootViewController];
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    
    NSLog(@"LookinServer - Failed to run local inspection. The feature has been removed. Please use the computer version of Lookin or consider SDKs like FLEX for similar functionality.");
}

- (void)_handleLocalInspectIn3D:(NSNotification *)note {
    UIAlertController  *alertController = [UIAlertController  alertControllerWithTitle:@"Lookin" message:@"Failed to run local inspection. The feature has been removed. Please use the computer version of Lookin or consider SDKs like FLEX for similar functionality."  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    UIApplication *app = [UIApplication  sharedApplication];
    UIWindow *keyWindow = [app keyWindow];
    UIViewController *rootViewController = [keyWindow rootViewController];
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    
    NSLog(@"LookinServer - Failed to run local inspection. The feature has been removed. Please use the computer version of Lookin or consider SDKs like FLEX for similar functionality.");
}

@end

/// 这个类使得用户可以通过 NSClassFromString(@"Lookin") 来判断 LookinServer 是否被编译进了项目里

@interface Lookin : NSObject

@end

@implementation Lookin

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
