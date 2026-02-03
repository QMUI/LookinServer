//
//  ECOSocketChannel.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOBaseChannel.h"
//#import "ECOCoreDefines.h"

typedef NS_ENUM(NSInteger, ECOSocketHeadTag) {
    ECOSocketHeadTag_Data   = 0,         //普通数据
    ECOSocketHeadTag_Device = 1,         //设备信息
    ECOSocketHeadTag_Authorization = 2,  //授权连接
    ECOSocketHeadTag_ClientListen = 3,   //Client监听Mac端的主动申请
};

typedef NS_ENUM(NSInteger, ECOSocketDataTag) {
    ECOSocketDataTag_Data   = 10,        //普通数据
    ECOSocketDataTag_Device = 11,        //设备信息
    ECOSocketDataTag_Authorization = 12, //授权连接
    ECOSocketDataTag_ClientListen = 13,  //Client监听Mac端的主动申请
};

//版本号，版本不一致忽略该数据
static const int ECOSocketProtocolVersion = 1;

//包体主协议，1表示授权连接，2表示发送数据，3表示Client侧接收主动申请
static const int ECOHeadMainType_Authorization = 1;
static const int ECOHeadMainType_Data = 2;
static const int ECOHeadMainType_ClientListen = 3;

//包体子协议，0表示JSON数据，1表示普通NSData数据
static const int ECOHeadSubType_JSON = 0;
static const int ECOHeadSubType_Data = 1;

@interface ECOSocketChannel : ECOBaseChannel

/// 设备白名单列表，记录始终允许的设备
@property (nonatomic, strong) NSMutableArray *whitelistDevices;

//连接到ip地址
- (void)autoConnectToClientIPAddress:(NSString *)ipAddress;

//Client侧连接Mac侧：连接到ip地址
- (void)connectToIPAddress:(NSString *)ip;

//发送数据
- (void)sendPacket:(NSData *)packet
//              type:(ECOPacketDataType)type
         extraInfo:(NSDictionary *)extraInfo
          toDevice:(ECOChannelDeviceInfo *)device;

//发送授权数据
- (void)sendAuthorizationMessageToDevice:(ECOChannelDeviceInfo *)device
                                    state:(ECOAuthorizeResponseType)responseType
                           showAuthAlert:(BOOL)showAuthAlert;

@end
