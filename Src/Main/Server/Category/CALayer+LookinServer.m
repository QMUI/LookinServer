#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIView+LookinMobile.m
//  WeRead
//
//  Created by Li Kai on 2018/11/30.
//  Copyright © 2018 tencent. All rights reserved.
//

#import "CALayer+LookinServer.h"
#import "LKS_HierarchyDisplayItemsMaker.h"
#import "LookinDisplayItem.h"
#import <objc/runtime.h>
#import "LKS_ConnectionManager.h"
#import "LookinIvarTrace.h"
#import "LookinServerDefines.h"
#import "UIColor+LookinServer.h"
#import "LKS_MultiplatformAdapter.h"
#import "NSWindow+LookinServer.h"

@implementation CALayer (LookinServer)

- (LookinWindow *)lks_window {
    CALayer *layer = self;
    while (layer) {
        LookinView *hostView = layer.lks_hostView;
        if (hostView.window) {
            return hostView.window;
#if !TARGET_OS_OSX
        } else if ([hostView isKindOfClass:[LookinWindow class]]) {
            return (LookinWindow *)hostView;
#endif
        }
        layer = layer.superlayer;
    }
    return nil;
}

- (CGRect)lks_frameInWindow:(LookinWindow *)window {
    LookinWindow *selfWindow = [self lks_window];
    if (!selfWindow) {
        return CGRectZero;
    }
    
#if TARGET_OS_IPHONE
    CGRect rectInSelfWindow = [selfWindow.layer convertRect:self.frame fromLayer:self.superlayer];
    CGRect rectInWindow = [window convertRect:rectInSelfWindow fromWindow:selfWindow];
#elif TARGET_OS_OSX
    CGRect rectInSelfWindow = [selfWindow.lks_rootView.layer convertRect:self.frame fromLayer:self.superlayer];
    CGRect rectInWindow = [window.lks_rootView convertRect:rectInSelfWindow fromView:selfWindow.lks_rootView];
#endif
    return rectInWindow;
}

#pragma mark - Host View

- (LookinView *)lks_hostView {
    if (self.delegate && [self.delegate isKindOfClass:LookinView.class]) {
        LookinView *view = (LookinView *)self.delegate;
        if (view.layer == self) {
            return view;
        }
    }
    return nil;
}

#pragma mark - Screenshot

- (LookinImage *)lks_groupScreenshotWithLowQuality:(BOOL)lowQuality {
    
    CGFloat screenScale = [LKS_MultiplatformAdapter mainScreenScale];
    CGFloat pixelWidth = self.frame.size.width * screenScale;
    CGFloat pixelHeight = self.frame.size.height * screenScale;
    if (pixelWidth <= 0 || pixelHeight <= 0) {
        return nil;
    }
    
    CGFloat renderScale = lowQuality ? 1 : 0;
    CGFloat maxLength = MAX(pixelWidth, pixelHeight);
    if (maxLength > LookinNodeImageMaxLengthInPx) {
        // 确保最终绘制出的图片长和宽都不能超过 LookinNodeImageMaxLengthInPx
        // 如果算出的 renderScale 大于 1 则取 1，因为似乎用 1 渲染的速度要比一个别的奇怪的带小数点的数字要更快
        renderScale = MIN(screenScale * LookinNodeImageMaxLengthInPx / maxLength, 1);
    }
    
    CGSize contextSize = self.frame.size;
    if (contextSize.width <= 0 || contextSize.height <= 0 || contextSize.width > 20000 || contextSize.height > 20000) {
        NSLog(@"LookinServer - Failed to capture screenshot. Invalid context size: %@ x %@", @(contextSize.width), @(contextSize.height));
        return nil;
    }
#if TARGET_OS_IPHONE
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, renderScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.lks_hostView && !self.lks_hostView.lks_isChildrenViewOfTabBar) {
        [self.lks_hostView drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:YES];
    } else {
        [self renderInContext:context];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
#elif TARGET_OS_OSX
    NSImage *image = nil;
    NSView *view = self.lks_hostView;
    if (view) {
        NSBitmapImageRep *representation = [view bitmapImageRepForCachingDisplayInRect:view.bounds];
        if (!representation) {
            return nil;
        }
        [view cacheDisplayInRect:view.bounds toBitmapImageRep:representation];
        image = [[NSImage alloc] initWithSize:representation.size];
        [image addRepresentation:representation];
        return image;
        
    } else {
        image = [[NSImage alloc] initWithSize:contextSize];
        [image lockFocusFlipped:self.isGeometryFlipped];
        CGContextRef context = NSGraphicsContext.currentContext.CGContext;
        [self renderInContext:context];
        [image unlockFocus];
    }
    return image;
#endif
}

- (LookinImage *)lks_soloScreenshotWithLowQuality:(BOOL)lowQuality {
    if (!self.sublayers.count) {
        return nil;
    }
    
    CGFloat screenScale = [LKS_MultiplatformAdapter mainScreenScale];
    CGFloat pixelWidth = self.frame.size.width * screenScale;
    CGFloat pixelHeight = self.frame.size.height * screenScale;
    if (pixelWidth <= 0 || pixelHeight <= 0) {
        return nil;
    }
    
    CGFloat renderScale = lowQuality ? 1 : 0;
    CGFloat maxLength = MAX(pixelWidth, pixelHeight);
    if (maxLength > LookinNodeImageMaxLengthInPx) {
        // 确保最终绘制出的图片长和宽都不能超过 LookinNodeImageMaxLengthInPx
        // 如果算出的 renderScale 大于 1 则取 1，因为似乎用 1 渲染的速度要比一个别的奇怪的带小数点的数字要更快
        renderScale = MIN(screenScale * LookinNodeImageMaxLengthInPx / maxLength, 1);
    }
    CGSize contextSize = self.frame.size;
    if (contextSize.width <= 0 || contextSize.height <= 0 || contextSize.width > 20000 || contextSize.height > 20000) {
        NSLog(@"LookinServer - Failed to capture screenshot. Invalid context size: %@ x %@", @(contextSize.width), @(contextSize.height));
        return nil;
    }
    if (self.sublayers.count) {
        NSArray<CALayer *> *sublayers = [self.sublayers copy];
        NSMutableArray<CALayer *> *visibleSublayers = [NSMutableArray arrayWithCapacity:sublayers.count];
        [sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull sublayer, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!sublayer.hidden) {
                sublayer.hidden = YES;
                [visibleSublayers addObject:sublayer];
            }
        }];
#if TARGET_OS_IPHONE
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, renderScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.lks_hostView && !self.lks_hostView.lks_isChildrenViewOfTabBar) {
            [self.lks_hostView drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:YES];
        } else {
            [self renderInContext:context];
        }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
#elif TARGET_OS_OSX
        NSImage *image = nil;
        NSView *view = self.lks_hostView;
        if (view) {
            NSBitmapImageRep *representation = [view bitmapImageRepForCachingDisplayInRect:view.bounds];
            if (!representation) {
                return nil;
            }
            [view cacheDisplayInRect:view.bounds toBitmapImageRep:representation];
            image = [[NSImage alloc] initWithSize:representation.size];
            [image addRepresentation:representation];
        } else {
            image = [[NSImage alloc] initWithSize:contextSize];
            [image lockFocusFlipped:self.isGeometryFlipped];
            CGContextRef context = NSGraphicsContext.currentContext.CGContext;
            [self renderInContext:context];
            [image unlockFocus];
        }
#endif
        [visibleSublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull sublayer, NSUInteger idx, BOOL * _Nonnull stop) {
            sublayer.hidden = NO;
        }];
        return image;
    }
    return nil;
}

- (NSArray<NSArray<NSString *> *> *)lks_relatedClassChainList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    if (self.lks_hostView) {
        [array addObject:[CALayer lks_getClassListOfObject:self.lks_hostView endingClass:LookinViewString]];
        NSViewController* vc = [self.lks_hostView lks_findHostViewController];
        if (vc) {
            [array addObject:[CALayer lks_getClassListOfObject:vc endingClass:LookinViewControllerString]];
        }
    } else {
        [array addObject:[CALayer lks_getClassListOfObject:self endingClass:@"CALayer"]];
    }
    return array.copy;
}

+ (NSArray<NSString *> *)lks_getClassListOfObject:(id)object endingClass:(NSString *)endingClass {
    NSArray<NSString *> *completedList = [object lks_classChainList];
    NSUInteger endingIdx = [completedList indexOfObject:endingClass];
    if (endingIdx != NSNotFound) {
        completedList = [completedList subarrayWithRange:NSMakeRange(0, endingIdx + 1)];
    }
    return completedList;
}

- (NSArray<NSString *> *)lks_selfRelation {
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray<LookinIvarTrace *> *ivarTraces = [NSMutableArray array];
    if (self.lks_hostView) {
        LookinViewController* vc = [self.lks_hostView lks_findHostViewController];
        if (vc) {
            [array addObject:[NSString stringWithFormat:@"(%@ *).view", NSStringFromClass(vc.class)]];
            
            [ivarTraces addObjectsFromArray:vc.lks_ivarTraces];
        }
        [ivarTraces addObjectsFromArray:self.lks_hostView.lks_ivarTraces];
    } else {
        [ivarTraces addObjectsFromArray:self.lks_ivarTraces];
    }
    if (ivarTraces.count) {
        [array addObjectsFromArray:[ivarTraces lookin_map:^id(NSUInteger idx, LookinIvarTrace *value) {
            return [NSString stringWithFormat:@"(%@ *) -> %@", value.hostClassName, value.ivarName];
        }]];
    }
    return array.count ? array.copy : nil;
}

- (LookinColor *)lks_backgroundColor {
    return [LookinColor lks_colorWithCGColor:self.backgroundColor];
}
- (void)setLks_backgroundColor:(LookinColor *)lks_backgroundColor {
    self.backgroundColor = lks_backgroundColor.CGColor;
}

- (LookinColor *)lks_borderColor {
    return [LookinColor lks_colorWithCGColor:self.borderColor];
}
- (void)setLks_borderColor:(LookinColor *)lks_borderColor {
    self.borderColor = lks_borderColor.CGColor;
}

- (LookinColor *)lks_shadowColor {
    return [LookinColor lks_colorWithCGColor:self.shadowColor];
}
- (void)setLks_shadowColor:(LookinColor *)lks_shadowColor {
    self.shadowColor = lks_shadowColor.CGColor;
}

- (CGFloat)lks_shadowOffsetWidth {
    return self.shadowOffset.width;
}
- (void)setLks_shadowOffsetWidth:(CGFloat)lks_shadowOffsetWidth {
    self.shadowOffset = CGSizeMake(lks_shadowOffsetWidth, self.shadowOffset.height);
}

- (CGFloat)lks_shadowOffsetHeight {
    return self.shadowOffset.height;
}
- (void)setLks_shadowOffsetHeight:(CGFloat)lks_shadowOffsetHeight {
    self.shadowOffset = CGSizeMake(self.shadowOffset.width, lks_shadowOffsetHeight);
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
