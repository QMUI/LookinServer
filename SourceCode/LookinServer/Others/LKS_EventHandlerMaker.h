//
//  LKS_EventHandlerMaker.h
//  LookinServer
//
//  Created by Li Kai on 2019/8/7.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <Foundation/Foundation.h>

@class LookinEventHandler;

@interface LKS_EventHandlerMaker : NSObject

+ (NSArray<LookinEventHandler *> *)makeForView:(UIView *)view;

@end

#endif
