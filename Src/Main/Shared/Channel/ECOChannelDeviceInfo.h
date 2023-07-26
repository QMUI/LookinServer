//
//  ECOChannelDeviceInfo.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/17. Maintain by 陈爱彬
//  Description 设备信息
//

#import <Foundation/Foundation.h>
#import "ECOChannelAppInfo.h"

typedef NS_ENUM(NSInteger, ECODeviceType) {
    ECODeviceType_Simulator = 0,     //模拟器
    ECODeviceType_Device,            //真机
    ECODeviceType_MacApp,            //Mac客户端
};

typedef NS_ENUM(NSInteger, ECOAuthorizeResponseType) {
    ECOAuthorizeResponseType_Deny = 0,      //拒绝连接
    ECOAuthorizeResponseType_AllowOnce,     //允许本次
    ECOAuthorizeResponseType_AllowAlways,   //始终允许
};

@interface ECOChannelDeviceInfo : NSObject

@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy, readonly) NSString *ipAddress;
@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy, readonly) NSString *deviceName;
@property (nonatomic, copy, readonly) NSString *systemVersion;
@property (nonatomic, copy, readonly) NSString *deviceModel;
@property (nonatomic, assign, readonly) ECODeviceType deviceType;
@property (nonatomic, assign) ECOAuthorizeResponseType authorizedType;
@property (nonatomic, assign) BOOL showAuthAlert;
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, strong, readonly) ECOChannelAppInfo *appInfo;

/**
 透传数据
 */
@property (nonatomic, copy) NSDictionary *extraData;

//解析网络信息传输过来的设备信息
- (instancetype)initWithData:(NSData *)data;

- (NSDictionary *)toJSONObject;

@end
