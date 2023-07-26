//
//  ECOChannelManager.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOChannelManager.h"

@interface ECOChannelManager()
<ECOChannelConnectedDeviceProtocol>

@property (nonatomic, strong) ECOUSBChannel *ptChannel;
@property (nonatomic, strong) ECOSocketChannel *socketChannel;

@end

@implementation ECOChannelManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _socketChannel = [[ECOSocketChannel alloc] initWithDelegate:self];
        _ptChannel = [[ECOUSBChannel alloc] initWithDelegate:self];
#if TARGET_OS_IPHONE
        __weak typeof(self) weakSelf = self;
        _ptChannel.attachBlock = ^(NSString *ipAddress) {
            [weakSelf.socketChannel connectToIPAddress:ipAddress];
        };
#endif
        
    }
    return self;
}

#pragma mark - 优先级管理

#pragma mark - 通道连接
- (void)connectToClientIPAddress:(NSString *)ipAddress {
    [self.socketChannel autoConnectToClientIPAddress:ipAddress];
}
#pragma mark - 数据传输
//发送数据
- (void)sendPacket:(NSData *)packet
//              type:(ECOPacketDataType)type
         extraInfo:(NSDictionary *)extraInfo
          toDevice:(ECOChannelDeviceInfo *)device {
    if (!packet ||
        ![packet isKindOfClass:[NSData class]]) {
        return;
    }
    [self.socketChannel sendPacket:packet extraInfo:extraInfo toDevice:device];
}
//接收数据
- (void)device:(ECOChannelDeviceInfo *)device receivePacket:(NSData *)packet extraInfo:(NSDictionary *)extraInfo {
    if (!packet) {
        return;
    }
    !self.receivedBlock ?: self.receivedBlock(device, packet, extraInfo);
}
//发送授权数据
- (void)sendAuthorizationMessageToDevice:(ECOChannelDeviceInfo *)device
                                    state:(ECOAuthorizeResponseType)responseType
                           showAuthAlert:(BOOL)showAuthAlert {
    if (!device ||
        ![device isKindOfClass:[ECOChannelDeviceInfo class]]) {
        return;
    }
    [self.socketChannel sendAuthorizationMessageToDevice:device state:responseType showAuthAlert:showAuthAlert];
}
#pragma mark - 连接状态
// 是否已连接到Mac客户端
- (BOOL)isConnected {
    BOOL isSocketConnected = [_socketChannel isConnected];
    return isSocketConnected;
}
#pragma mark - ECOChannelConnectedDeviceProtocol methods
- (void)channel:(ECOBaseChannel *)channel didConnectedToDevice:(ECOChannelDeviceInfo *)device {
    NSLog(@">> [ECOChannelManager] did Connected to device:%@", [device description]);
//    //状态回调
//    if (device.authorizedType != ECOAuthorizeResponseType_Deny) {
//        !self.connectBlock ?: self.connectBlock([self isConnected]);
//    }
    //连接设备状态
    !self.deviceBlock ?: self.deviceBlock(device, YES);
}
- (void)channel:(ECOBaseChannel *)channel didDisconnectWithDevice:(ECOChannelDeviceInfo *)device {
    NSLog(@">> [ECOChannelManager] did Disconnect to device:%@", [device description]);
//    //状态回调
//    if (device.authorizedType != ECOAuthorizeResponseType_Deny) {
//        !self.connectBlock ?: self.connectBlock([self isConnected]);
//    }
    //连接设备状态
    !self.deviceBlock ?: self.deviceBlock(device, NO);
}
- (void)channel:(ECOBaseChannel *)channel didReceivedDevice:(ECOChannelDeviceInfo *)device andData:(NSData *)data extraInfo:(NSDictionary *)extraInfo{
//    NSLog(@">> [ECOChannelManager] did Received data from device:%@", [device description]);
    [self device:device receivePacket:data extraInfo:extraInfo];
}

- (void)channel:(ECOBaseChannel *)channel device:(ECOChannelDeviceInfo *)device didChangedAuthState:(ECOAuthorizeResponseType)authorizedType {
    NSLog(@">> [ECOChannelManager] device did changed authState:%@", @(authorizedType));
    !self.authStateChangedBlock ?: self.authStateChangedBlock(device, authorizedType);
}
- (void)channel:(ECOBaseChannel *)channel device:(ECOChannelDeviceInfo *)device willRequestAuthState:(ECOAuthorizeResponseType)authorizedType {
    NSLog(@">> [ECOChannelManager] device will request authState:%@", @(authorizedType));
    !self.requestAuthBlock ?: self.requestAuthBlock(device, authorizedType);
}

- (NSMutableArray *)whitelistDevices {
	return self.socketChannel.whitelistDevices;
}

@end
