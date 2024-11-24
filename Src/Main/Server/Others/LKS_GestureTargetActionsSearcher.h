#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LKS_GestureTargetActionsSearcher.h
//  LookinServer
//
//  Created by likai.123 on 2023/9/11.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

#import "LookinDefines.h"

@class LookinTwoTuple;

NS_ASSUME_NONNULL_BEGIN

@interface LKS_GestureTargetActionsSearcher : NSObject

/// 返回一个 UIGestureRecognizer 实例身上绑定的 target & action 信息
/// tuple.first => LookinWeakContainer(包裹着 target)，tuple.second => action(方法名字符串)
+ (NSArray<LookinTwoTuple *> *)getTargetActionsFromRecognizer:(LookinGestureRecognizer *)recognizer;

@end

NS_ASSUME_NONNULL_END

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
