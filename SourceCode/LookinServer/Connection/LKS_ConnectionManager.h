//
//  LKS_ConnectionManager.h
//  LookinServer
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const LKS_ConnectionDidEndNotificationName;

@class LookinConnectionResponseAttachment;

@interface LKS_ConnectionManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, assign) BOOL applicationIsActive;

- (BOOL)isConnected;

- (void)respond:(LookinConnectionResponseAttachment *)data requestType:(uint32_t)requestType tag:(uint32_t)tag;

- (void)pushData:(NSObject *)data type:(uint32_t)type;

@end
