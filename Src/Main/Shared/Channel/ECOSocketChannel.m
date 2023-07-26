//
//  ECOSocketChannel.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOSocketChannel.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <pthread.h>
#include <string.h>

#import "ECONetServicePublisher.h"
#import "ECONetServiceBrowser.h"

#import "LookinDefines.h"

//static uint16_t const  ECOClientSockeListenPortNumber = 23235;
//static uint16_t const  ECOSocketAcceptPortNumber = 23234;
static CGFloat const ECOSocketRetryListenDelay   = 1.f;
static NSInteger const ECOSocketHeadOffsetValue  = 10;
static NSString *const ECHOAuthorizedDevicesKey = @"echoAuthorizedDevicesKey";

@interface ECOSocketChannel()
<GCDAsyncSocketDelegate> {
    NSRecursiveLock *_socketLock;
}
@property (nonatomic, strong) NSMutableArray *sockets;
@property (nonatomic, strong) GCDAsyncSocket *mSocket;
@property (nonatomic, strong) ECONetServicePublisher *publisher;
@property (nonatomic, strong) ECONetServiceBrowser *browser;
//Client端主动连接的监听socket
@property (nonatomic, strong) GCDAsyncSocket *cSocket;
@property (nonatomic, strong) NSMutableArray *clientSockets;

@end

@implementation ECOSocketChannel

- (void)dealloc {
    NSLog(@"%s",__func__);
}
//初始化
- (void)setupChannel {
    [super setupChannel];
    _socketLock = [[NSRecursiveLock alloc] init];
    self.priority = ECOChannelPriority_Socket;
    
    //开启服务监听
#if TARGET_OS_OSX
    [self startListening];
#else
    [self setupClientListenSocket];
    [self.browser startBrowsing];
#endif
}
//是否有socket连接
- (BOOL)isConnected {
    BOOL v = NO;
    [self p_lock];
    if (self.connectType == ECOChannelConnectType_Authorization) {
        for (GCDAsyncSocket *socket in self.sockets) {
            ECOChannelDeviceInfo *deviceInfo = socket.userData;
            if (deviceInfo.authorizedType != ECOAuthorizeResponseType_Deny) {
                v = YES;
                break;
            }
        }
    }else{
        NSInteger count = [self.sockets count];
        v = count != 0;
    }
    [self p_unlock];
    return v;
}
//判断某个设备是否已连接
- (BOOL)isEchoConnectedOfDevice:(ECOChannelDeviceInfo *)device {
    BOOL v = NO;
    [self p_lock];
    for (GCDAsyncSocket *socket in self.sockets) {
        ECOChannelDeviceInfo *deviceInfo = socket.userData;
        if ([device.ipAddress isEqualToString:deviceInfo.ipAddress]) {
            v = YES;
            break;
        }
    }
    [self p_unlock];
    return v;
}
- (void)setupClientListenSocket {
    self.cSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    [self.cSocket acceptOnPort:LookinClientSockeListenPortNumber error:&error];
    if (error) {
        NSLog(@"Socket Listen error:%@", error);
        self.cSocket.delegate = nil;
        self.cSocket = nil;
    }
}
- (void)startListening {
    [self p_lock];
    [self.sockets removeAllObjects];
    [self p_unlock];
    /*
     https://developer.apple.com/library/archive/documentation/Networking/Conceptual/NSNetServiceProgGuide/Articles/PublishingServices.html
     创建listening socket for communication
     */
    self.mSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    BOOL isAccept = [self.mSocket acceptOnPort:LookinSocketAcceptPortNumber error:&error];
    if (error) {
        NSLog(@"Socket Listen error:%@", error);
        self.mSocket.delegate = nil;
        self.mSocket = nil;
        [self restartListening];
        return;
    }
    NSLog(@"Socket Listen:%@", isAccept ? @"Success" : @"Failure");
    //启动NetService
    [self.publisher startPublish];
}

//重试监听
- (void)restartListening {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ECOSocketRetryListenDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startListening];
    });
}
#pragma mark - Socket连接
//Client侧连接Mac侧
- (void)connectToAddresses:(NSArray<NSData *> *)addresses
                  hostName:(NSString *)hostName {
    if (!addresses || ![addresses count]) {
        return;
    }
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSData *address = [addresses objectAtIndex:0];
    NSError *error = nil;
    BOOL connected = [socket connectToAddress:address error:&error];
    if (connected) {
        [self p_lock];
        [self.sockets addObject:socket];
        [self p_unlock];
        //发送设备信息
        [self sendDeviceInfo:socket hostName:hostName];
    }
    if (error) {
        NSLog(@">> [ECOSocketChannel] connect to address failed:%@", error);
    }
}
//Client侧连接Mac侧：连接到ip地址
- (void)connectToIPAddress:(NSString *)ip {
    if (!ip || ![ip length]) {
        return;
    }
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    BOOL connected = [socket connectToHost:ip onPort:LookinSocketAcceptPortNumber error:&error];
    if (connected) {
        [self p_lock];
        [self.sockets addObject:socket];
        [self p_unlock];
        //发送设备信息
        [self sendDeviceInfo:socket hostName:nil];
    }
    if (error) {
        NSLog(@">> [ECOSocketChannel] connect to address failed:%@", error);
    }
}
//Mac侧连接Client侧
- (void)autoConnectToClientIPAddress:(NSString *)ipAddress {
    if (!ipAddress || ![ipAddress length]) {
        return;
    }
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    BOOL connected = [socket connectToHost:ipAddress onPort:LookinClientSockeListenPortNumber error:&error];
    if (connected) {
        [self.clientSockets addObject:socket];
        //发送本Mac侧的信息
        [self sendMacAutoConnectInfoInfo:socket];
    }
    if (error) {
        NSLog(@">> [ECOSocketChannel] autoConnectToClientIPAddress failed:%@", error);
    }
}
#pragma mark - Socket通信
//发送数据
- (void)sendPacket:(NSData *)packet
//              type:(ECOPacketDataType)type
         extraInfo:(NSDictionary *)extraInfo
          toDevice:(ECOChannelDeviceInfo *)device {
    if (!packet) {
        return;
    }

    NSMutableData *buffer = [[NSMutableData alloc] init];
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setValue:@(ECOSocketProtocolVersion) forKey:@"version"];
    [header setValue:@(ECOHeadMainType_Data) forKey:@"mType"];
//    [header setValue:@(type) forKey:@"sType"];
    [header setValue:@([packet length]) forKey:@"len"];
//    if (type == ECOPacketDataType_Data) {
        [header setValue:extraInfo forKey:@"extra"];
//    }
    NSData *headData = [NSJSONSerialization dataWithJSONObject:header options:0 error:nil];
    [buffer appendData:headData];
    [buffer appendData:[GCDAsyncSocket CRLFData]];
    [buffer appendBytes:[packet bytes] length:[packet length]];

    [self p_lock];
    for (GCDAsyncSocket *socket in self.sockets) {
        if (self.connectType == ECOChannelConnectType_Authorization) {
            //授权机制
            ECOChannelDeviceInfo *deviceInfo = socket.userData;
            if (deviceInfo.authorizedType != ECOAuthorizeResponseType_Deny) {
                if (device != nil) {
                    //给单个设备发送消息
                    if ([device isEqual:deviceInfo]) {
                        [socket writeData:buffer withTimeout:-1 tag:ECOSocketHeadTag_Data];
                    }
                }else{
                    //给所有设备发送消息
                    [socket writeData:buffer withTimeout:-1 tag:ECOSocketHeadTag_Data];
                }
            }
        }else{
            [socket writeData:buffer withTimeout:-1 tag:ECOSocketHeadTag_Data];
        }
    }
    [self p_unlock];
}
//发送授权数据
- (void)sendAuthorizationMessageToDevice:(ECOChannelDeviceInfo *)device
                                    state:(ECOAuthorizeResponseType)responseType
                           showAuthAlert:(BOOL)showAuthAlert {
    //修改数据
    ECOChannelDeviceInfo *authDevice = device;
    device.showAuthAlert = showAuthAlert;
#if TARGET_OS_OSX
    if (responseType != ECOAuthorizeResponseType_Deny) {
        //允许需要等待对方确认,稍后修改device的内容
        authDevice = [device copy];
    }
#endif
    authDevice.authorizedType = responseType;
    NSError *error = nil;
    NSData *packet = [NSJSONSerialization dataWithJSONObject:[authDevice toJSONObject] options:0 error:&error];
    if (error) {
        NSLog(@">>[ECOCoreManager] send AuthorizationResponse failed:%@", error);
    }
    [self p_lock];
    for (GCDAsyncSocket *socket in self.sockets) {
        ECOChannelDeviceInfo *deviceInfo = socket.userData;
        if ([deviceInfo isEqual:authDevice]) {
            NSMutableData *buffer = [[NSMutableData alloc] init];
            NSMutableDictionary *header = [NSMutableDictionary dictionary];
            [header setValue:@(ECOSocketProtocolVersion) forKey:@"version"];
            [header setValue:@(ECOHeadMainType_Authorization) forKey:@"mType"];
            [header setValue:@(ECOHeadSubType_JSON) forKey:@"sType"];
            [header setValue:@([packet length]) forKey:@"len"];
            NSData *headData = [NSJSONSerialization dataWithJSONObject:header options:0 error:nil];
            [buffer appendData:headData];
            [buffer appendData:[GCDAsyncSocket CRLFData]];
            [buffer appendBytes:[packet bytes] length:[packet length]];
            [socket writeData:buffer withTimeout:-1 tag:ECOSocketHeadTag_Data];
        }
    }
    [self p_unlock];
    
#if TARGET_OS_OSX
    //授权连接回调,手动断开时主动回调，主动连接时等收到对方的消息再回调
    if (responseType == ECOAuthorizeResponseType_Deny) {
        if ([self.delegate respondsToSelector:@selector(channel:device:didChangedAuthState:)]) {
            [self.delegate channel:self device:device didChangedAuthState:NO];
        }
        //修改授权白名单
        if (device.uuid.length > 0) {
            NSString *uniId = [NSString stringWithFormat:@"%@_%@",device.uuid, device.appInfo.appId];
            if ([self.whitelistDevices containsObject:uniId]) {
                [self.whitelistDevices removeObject:uniId];
                [self saveWhiteListDevices];
            }
        }
    }
#else
    if ([self.delegate respondsToSelector:@selector(channel:device:didChangedAuthState:)]) {
        [self.delegate channel:self device:device didChangedAuthState:responseType];
    }
#endif
    
}
//发送设备信息
- (void)sendDeviceInfo:(GCDAsyncSocket *)socket
              hostName:(NSString *)hostName {
    ECOChannelDeviceInfo *deviceInfo = [ECOChannelDeviceInfo new];
    deviceInfo.hostName = hostName;
    NSData *packet = [NSJSONSerialization dataWithJSONObject:[deviceInfo toJSONObject] options:0 error:nil];
    if (!packet) {
        return;
    }
    NSMutableData *buffer = [[NSMutableData alloc] init];
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setValue:@(ECOSocketProtocolVersion) forKey:@"version"];
    [header setValue:@(ECOHeadMainType_Data) forKey:@"mType"];
    [header setValue:@(ECOHeadSubType_JSON) forKey:@"sType"];
    [header setValue:@([packet length]) forKey:@"len"];
    NSData *headData = [NSJSONSerialization dataWithJSONObject:header options:0 error:nil];
    [buffer appendData:headData];
    [buffer appendData:[GCDAsyncSocket CRLFData]];
    [buffer appendBytes:[packet bytes] length:[packet length]];
    [socket writeData:buffer withTimeout:-1 tag:ECOSocketHeadTag_Device];
}
//发送给Client侧消息
- (void)sendMacAutoConnectInfoInfo:(GCDAsyncSocket *)socket {
    ECOChannelDeviceInfo *deviceInfo = [ECOChannelDeviceInfo new];
    NSData *packet = [NSJSONSerialization dataWithJSONObject:[deviceInfo toJSONObject] options:0 error:nil];
    if (!packet) {
        return;
    }
    NSMutableData *buffer = [[NSMutableData alloc] init];
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setValue:@(ECOSocketProtocolVersion) forKey:@"version"];
    [header setValue:@(ECOHeadMainType_ClientListen) forKey:@"mType"];
    [header setValue:@(ECOHeadSubType_JSON) forKey:@"sType"];
    [header setValue:@([packet length]) forKey:@"len"];
    NSData *headData = [NSJSONSerialization dataWithJSONObject:header options:0 error:nil];
    [buffer appendData:headData];
    [buffer appendData:[GCDAsyncSocket CRLFData]];
    [buffer appendBytes:[packet bytes] length:[packet length]];
    [socket writeData:buffer withTimeout:-1 tag:ECOSocketHeadTag_ClientListen];
}
#pragma mark - GCDAsyncSocketDelegate methods
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    //        NSLog(@"%s",__func__);
#if TARGET_OS_IPHONE
    //读取数据
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:ECOSocketHeadTag_Device];
#endif
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    //    NSLog(@"%s",__func__);
#if TARGET_OS_OSX
    [self p_lock];
    [self.sockets addObject:newSocket];
    newSocket.delegate = self;
    [newSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:ECOSocketHeadTag_Device];
    [self p_unlock];
    //发送设备信息
    [self sendDeviceInfo:newSocket hostName:nil];
#else
    [self.clientSockets addObject:newSocket];
    newSocket.delegate = self;
    [newSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:ECOSocketHeadTag_ClientListen];
#endif
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    NSLog(@"%s",__func__);
    if (tag == ECOSocketHeadTag_Data ||
        tag == ECOSocketHeadTag_Device ||
        tag == ECOSocketHeadTag_ClientListen) {
        NSData *headerData = [data subdataWithRange:NSMakeRange(0, data.length - [GCDAsyncSocket CRLFData].length)];
        NSDictionary *header = [NSJSONSerialization JSONObjectWithData:headerData options:NSJSONReadingAllowFragments error:nil];
        NSInteger version = [header[@"version"] integerValue];
        if (version < ECOSocketProtocolVersion) {
            return;
        }
        NSInteger length = [header[@"len"] integerValue];
        NSInteger mainType = [header[@"mType"] integerValue];
        if (mainType == ECOHeadMainType_Authorization) {
            [sock readDataToLength:length withTimeout:-1 tag:ECOSocketDataTag_Authorization];
        }else if(mainType == ECOHeadMainType_Data) {
            ECOChannelDeviceInfo *deviceInfo = sock.userData;
            NSDictionary *extraInfo = header[@"extra"];
            deviceInfo.extraData = extraInfo;
            [sock readDataToLength:length withTimeout:-1 tag:tag + ECOSocketHeadOffsetValue];
        }else if (mainType == ECOHeadMainType_ClientListen) {
            [sock readDataToLength:length withTimeout:-1 tag:tag + ECOSocketHeadOffsetValue];
        }
        return;
    }
    if (tag == ECOSocketDataTag_Device) {
        ECOChannelDeviceInfo *deviceInfo = [[ECOChannelDeviceInfo alloc] initWithData:data];
        sock.userData = deviceInfo;
#if TARGET_OS_OSX
        NSString *uniId = [NSString stringWithFormat:@"%@_%@",deviceInfo.uuid, deviceInfo.appInfo.appId];
        if ([self.whitelistDevices containsObject:uniId]) {
            //设置为已授权
            deviceInfo.authorizedType = ECOAuthorizeResponseType_AllowAlways;
            [self sendAuthorizationMessageToDevice:deviceInfo state:ECOAuthorizeResponseType_AllowAlways showAuthAlert:NO];
        }
#endif
        deviceInfo.isConnected = YES;
        //连接到新设备
        if ([self.delegate respondsToSelector:@selector(channel:didConnectedToDevice:)]) {
            [self.delegate channel:self didConnectedToDevice:deviceInfo];
        }
    }
    if (tag == ECOSocketDataTag_ClientListen) {
        ECOChannelDeviceInfo *deviceInfo = [[ECOChannelDeviceInfo alloc] initWithData:data];
        BOOL isConnected = [self isEchoConnectedOfDevice:deviceInfo];
        if (!isConnected) {
            [self connectToIPAddress:deviceInfo.ipAddress];
        }else{
            NSLog(@"当前Echo主机已连接:%@",deviceInfo.ipAddress);
        }
        [sock setDelegate:nil];
        [self.clientSockets removeObject:sock];
    }
    if (tag == ECOSocketDataTag_Authorization) {
        //授权信息
        ECOChannelDeviceInfo *deviceInfo = sock.userData;
        ECOChannelDeviceInfo *tempDevice = [[ECOChannelDeviceInfo alloc] initWithData:data];
        BOOL isAlwaysAllow = tempDevice.authorizedType == ECOAuthorizeResponseType_AllowAlways;
#if TARGET_OS_IPHONE
        deviceInfo.hostName = tempDevice.hostName;
        if (tempDevice.showAuthAlert) {
            //弹窗提示用户
            if ([self.delegate respondsToSelector:@selector(channel:device:willRequestAuthState:)]) {
                [self.delegate channel:self device:deviceInfo willRequestAuthState:tempDevice.authorizedType];
            }
        }else{
            deviceInfo.authorizedType = tempDevice.authorizedType;
            //连接到新设备
            if ([self.delegate respondsToSelector:@selector(channel:device:didChangedAuthState:)]) {
                [self.delegate channel:self device:deviceInfo didChangedAuthState:tempDevice.authorizedType];
            }
        }
#endif
#if TARGET_OS_OSX
        //修改设备的授权状态
        deviceInfo.authorizedType = tempDevice.authorizedType;
        //重置标记位
        deviceInfo.showAuthAlert = NO;
        //始终允许，加入白名单
        if (deviceInfo.uuid.length > 0) {
            NSString *uniId = [NSString stringWithFormat:@"%@_%@",deviceInfo.uuid, deviceInfo.appInfo.appId];
            if (isAlwaysAllow && ![self.whitelistDevices containsObject:uniId]) {
                [self.whitelistDevices addObject:uniId];
                [self saveWhiteListDevices];
            }else if (!isAlwaysAllow && [self.whitelistDevices containsObject:uniId]){
                [self.whitelistDevices removeObject:uniId];
                [self saveWhiteListDevices];
            }
        }
        //回调
        if ([self.delegate respondsToSelector:@selector(channel:device:didChangedAuthState:)]) {
            [self.delegate channel:self device:deviceInfo didChangedAuthState:tempDevice.authorizedType];
        }
#endif
    }
    //传递数据给上层
    if (tag == ECOSocketDataTag_Data) {
        if ([self.delegate respondsToSelector:@selector(channel:didReceivedDevice:andData:extraInfo:)]) {
            ECOChannelDeviceInfo *deviceInfo = sock.userData;
            if (deviceInfo.authorizedType != ECOAuthorizeResponseType_Deny) {
                //未授权的通信忽略
                [self.delegate channel:self didReceivedDevice:deviceInfo andData:data extraInfo:deviceInfo.extraData];
            }
        }
    }
    //读取下次发送的数据
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:ECOSocketHeadTag_Data];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
//    NSLog(@"%s",__func__);
    [self p_lock];
    [sock setDelegate:nil];
    if ([self.sockets containsObject:sock]) {
        if ([self.delegate respondsToSelector:@selector(channel:didDisconnectWithDevice:)]) {
            ECOChannelDeviceInfo *deviceInfo = sock.userData;
            deviceInfo.isConnected = NO;
            [self.delegate channel:self didDisconnectWithDevice:deviceInfo];
        }
        [self.sockets removeObject:sock];
    }
    if ([self.clientSockets containsObject:sock]) {
        [self.clientSockets removeObject:sock];
    }
    [self p_unlock];
    //重启监听
    if (sock == self.mSocket) {
        [self restartListening];
    }
}
#pragma mark - helper
- (void)p_lock {
    [_socketLock lock];
}
- (void)p_unlock {
    [_socketLock unlock];
}
- (void)saveWhiteListDevices {
    NSArray *list = [self.whitelistDevices copy];
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:ECHOAuthorizedDevicesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - getters
- (NSMutableArray *)sockets {
    if (!_sockets) {
        _sockets = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _sockets;
}
- (NSMutableArray *)clientSockets {
    if (!_clientSockets) {
        _clientSockets = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _clientSockets;
}

#if TARGET_OS_OSX
- (ECONetServicePublisher *)publisher {
    if (!_publisher) {
        _publisher = [[ECONetServicePublisher alloc] init];
    }
    return _publisher;
}
#endif


#if TARGET_OS_IPHONE
- (ECONetServiceBrowser *)browser {
    if (!_browser) {
        _browser = [[ECONetServiceBrowser alloc] init];
        __weak typeof(self) weakSelf = self;
        _browser.addressesBlock = ^(NSArray<NSData *> *addresses, NSString *hostName) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf connectToAddresses:addresses hostName:hostName];
        };
    }
    return _browser;
}
#endif

- (NSMutableArray *)whitelistDevices {
    if (!_whitelistDevices) {
        NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:ECHOAuthorizedDevicesKey];
        _whitelistDevices = [NSMutableArray arrayWithArray:list ?: @[]];
    }
    return _whitelistDevices;
}
@end
