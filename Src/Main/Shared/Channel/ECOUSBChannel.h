//
//  ECOUSBChannel.h
//  Echo
//
//  Created by 陈爱彬 on 2019/4/16. Maintain by 陈爱彬
//  Description 
//

#import "ECOBaseChannel.h"

typedef NS_ENUM(NSInteger, ECOUSBChannelType) {
    ECOUSBChannelType_Command = 100,
    ECOUSBChannelType_TextMessage = 101,
    ECOUSBChannelType_Ping = 102,
    ECOUSBChannelType_Pong = 103,
};

typedef struct _ECOUSBChannelTextFrame {
    uint32_t length;
    uint8_t utf8text[0];
} ECOUSBChannelTextFrame;

typedef void(^ECOUSBChannelDidAttachBlock)(NSString *ipAddress);

@interface ECOUSBChannel : ECOBaseChannel

@property (nonatomic, copy) ECOUSBChannelDidAttachBlock attachBlock;

@end
