//
//  LookinMobile.m
//  LookinMobile
//
//  Created by 李凯 on 2018/8/5.
//  Copyright © 2018年 hughkli. All rights reserved.
//

#import "LKI_ConnectionManager.h"
#import "PTChannel.h"
#import "LookinDefines.h"
#import "LKI_RequestHandler.h"
#import "LookinConnectionResponseAttachment.h"

@interface LKI_ConnectionManager () <PTChannelDelegate>

@property(nonatomic, weak) PTChannel *serverChannel_;
@property(nonatomic, weak) PTChannel *peerChannel_;

@property(nonatomic, strong) LKI_RequestHandler *requestHandler;

@end

@implementation LKI_ConnectionManager

+ (void)load {
    //NSLog(@"LookinMobile 即将启动");
    [[LKI_ConnectionManager sharedInstance] start];
}

+ (instancetype)sharedInstance {
    static LKI_ConnectionManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LKI_ConnectionManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.requestHandler = [LKI_RequestHandler new];
    }
    return self;
}

- (void)start {
    [self listenOnPort:LookinConnectionIPv4PortNumberStart];
}

- (void)listenOnPort:(int)port {
    if (port > LookinConnectionIPv4PortNumberEnd) {
        //NSLog(@"LookinMobile - listenOnPort 尝试端口值已超过最大值，终止尝试");
        return;
    }
    //NSLog(@"LookinMobile - %@", [NSString stringWithFormat:@"尝试监听地址：127.0.0.1:%d ……", port]);
    
    PTChannel *channel = [PTChannel channelWithDelegate:self];
    [channel listenOnPort:port IPv4Address:INADDR_LOOPBACK callback:^(NSError *error) {
        if (error) {
            if (error.code == 48) {
                NSString *string = [NSString stringWithFormat:@"尝试监听地址失败，该地址已被占用：127.0.0.1:%d: %@", port, error];
                //NSLog(@"LookinMobile - %@", string);
                
                [self listenOnPort:(port + 1)];
                
            } else {
                //NSLog(@"LookinMobile - %@", [NSString stringWithFormat:@"尝试监听地址失败 127.0.0.1:%d: %@", port, error]);
            }
        } else {
            //NSLog(@"LookinMobile - %@", [NSString stringWithFormat:@"成功开始监听地址 127.0.0.1:%d", port]);
            self.serverChannel_ = channel;
        }
    }];
}

- (void)dealloc {
    if (self.serverChannel_) {
        [self.serverChannel_ close];
    }
}

- (void)submitResponseAttachment:(LookinConnectionResponseAttachment *)attachment requestType:(uint32_t)requestType tag:(uint32_t)tag {
    if (self.peerChannel_) {
        if (requestType == LookinRequestTypeHierarchy) {
//            [[LookinTimerManager sharedInstance].timer startStage:@"传输 hierarchy"];
//            attachment.timer = [LookinTimerManager sharedInstance].timer;
//            NSString *stageTitle = [NSString stringWithFormat:@"传输数据 type:%@", @(requestType)];
//            [[LookinTimerManager sharedInstance].timer startStage:stageTitle];
        }

//        attachment.timer = [LookinTimerManager sharedInstance].timer;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:attachment];
        dispatch_data_t payload = [data createReferencingDispatchData];
        
        [self.peerChannel_ sendFrameOfType:requestType tag:tag withPayload:payload callback:^(NSError *error) {
            if (error) {
            }
        }];
    } else {
    }
}

#pragma mark - PTChannelDelegate

- (BOOL)ioFrameChannel:(PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    if (channel != self.peerChannel_) {
        return NO;
    } else if ([self.requestHandler canHandleRequestType:type]) {
        return YES;
    } else {
        //NSLog(@"LookinMobile - 已拒绝未被允许的信息类型 - %u", type);
        [channel close];
        return NO;
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(PTData*)payload {
    id object = nil;
    if (payload) {
        id unarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfDispatchData:payload.dispatchData]];
        if ([unarchivedObject isKindOfClass:[LookinConnectionAttachment class]]) {
            LookinConnectionAttachment *attachment = (LookinConnectionAttachment *)unarchivedObject;
            object = attachment.data;
//            [LookinTimerManager sharedInstance].timer = attachment.timer;
        } else {
            NSAssert(NO, @"");
        }
    }
    [self.requestHandler handleRequestType:type tag:tag object:object];
}

- (void)ioFrameChannel:(PTChannel*)channel didEndWithError:(NSError*)error {
    if (error) {
        NSString *string = [NSString stringWithFormat:@"%@ 链接中止: %@", channel, error];
        //NSLog(@"LookinMobile - %@", string);
    } else {
        //NSLog(@"LookinMobile - 断开链接：%@", channel.userInfo);
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didAcceptConnection:(PTChannel*)otherChannel fromAddress:(PTAddress*)address {
    if (self.peerChannel_) {
        [self.peerChannel_ cancel];
    }
    
    self.peerChannel_ = otherChannel;
    self.peerChannel_.userInfo = address;
    //NSLog(@"LookinMobile - 成功链接至 %@:%@", address.name, @(address.port));
}

@end
