//
//  ECOBaseChannel.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/18. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
#import "ECOChannelDeviceInfo.h"

// 通道优先级，usb > socket
typedef NS_ENUM(NSInteger, ECOChannelPriority) {
    ECOChannelPriority_Socket = 0,
    ECOChannelPriority_USB,
};

typedef NS_ENUM(NSInteger, ECOChannelConnectType) {
    ECOChannelConnectType_Authorization = 0,  //授权连接
    ECOChannelConnectType_Auto,               //自动连接
};

@class ECOBaseChannel;
@protocol ECOChannelConnectedDeviceProtocol <NSObject>

@optional
//新的设备连接
- (void)channel:(ECOBaseChannel *)channel didConnectedToDevice:(ECOChannelDeviceInfo *)device;
//设备已断开
- (void)channel:(ECOBaseChannel *)channel didDisconnectWithDevice:(ECOChannelDeviceInfo *)device;
//接收到数据
- (void)channel:(ECOBaseChannel *)channel didReceivedDevice:(ECOChannelDeviceInfo *)device andData:(NSData *)data extraInfo:(NSDictionary *)extraInfo;

//设备变更了授权状态
- (void)channel:(ECOBaseChannel *)channel device:(ECOChannelDeviceInfo *)device didChangedAuthState:(ECOAuthorizeResponseType)authorizedType;

//设备要请求授权状态，弹窗展示
- (void)channel:(ECOBaseChannel *)channel device:(ECOChannelDeviceInfo *)device willRequestAuthState:(ECOAuthorizeResponseType)authorizedType;

@end

@interface ECOBaseChannel : NSObject

@property (nonatomic, assign) ECOChannelPriority priority;
@property (nonatomic, weak) id<ECOChannelConnectedDeviceProtocol> delegate;
@property (nonatomic, assign) ECOChannelConnectType connectType;

- (instancetype)initWithDelegate:(id<ECOChannelConnectedDeviceProtocol>)delegate;
- (instancetype)init NS_UNAVAILABLE;

//初始化Channel，供子类调用，该方法会在初始化后自动被调用
- (void)setupChannel;

// 是否已连接到Mac客户端
- (BOOL)isConnected;

@end
