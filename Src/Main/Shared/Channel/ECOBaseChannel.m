//
//  ECOBaseChannel.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/18. Maintain by 陈爱彬
//  Description 
//

#import "ECOBaseChannel.h"

@implementation ECOBaseChannel

- (instancetype)initWithDelegate:(id<ECOChannelConnectedDeviceProtocol>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        //目前使用授权连接机制，如果想自动连接已发现的设备，将该值改为ECOChannelConnectType_Auto
        self.connectType = ECOChannelConnectType_Authorization;
        [self setupChannel];
    }
    return self;
}

//初始化Channel，供子类调用，该方法会在初始化后自动被调用
- (void)setupChannel {
    
}

// 是否已连接到Mac客户端
- (BOOL)isConnected {
    return NO;
}
@end
