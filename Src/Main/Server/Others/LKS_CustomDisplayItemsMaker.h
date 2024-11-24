#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LKS_CustomDisplayItemsMaker.h
//  LookinServer
//
//  Created by likai.123 on 2023/11/1.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

#import "LookinDefines.h"

@class LookinDisplayItem;

@interface LKS_CustomDisplayItemsMaker : NSObject

- (instancetype)initWithLayer:(CALayer *)layer saveAttrSetter:(BOOL)saveAttrSetter;
#if TARGET_OS_OSX
- (instancetype)initWithView:(NSView *)view saveAttrSetter:(BOOL)saveAttrSetter;
#endif

- (NSArray<LookinDisplayItem *> *)make;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
