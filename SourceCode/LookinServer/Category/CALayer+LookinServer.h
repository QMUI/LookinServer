//
//  CALayer+LookinServer.h
//
//
//  Copyright © 2018 tencent. All rights reserved.
//

#import "TargetConditionals.h"
#import <UIKit/UIKit.h>

@interface CALayer (LookinServer)

@property(nonatomic, weak) UIView *lks_hostView;

- (UIWindow *)lks_window;

- (CGRect)lks_frameInWindow:(UIWindow *)window;

@property(nonatomic, assign) BOOL lks_isLookinPrivateLayer;

/// 如果该属性为 YES，则该 layer 及所有下级 layers 均不会被转为 LookinDisplayItem
@property(nonatomic, assign) BOOL lks_avoidCapturing;

- (UIImage *)lks_groupScreenshotWithLowQuality:(BOOL)lowQuality;
/// 当没有 sublayers 时，该方法返回 nil
- (UIImage *)lks_soloScreenshotWithLowQuality:(BOOL)lowQuality;

@property(nonatomic, strong) UIColor *lks_backgroundColor;
@property(nonatomic, strong) UIColor *lks_borderColor;
@property(nonatomic, strong) UIColor *lks_shadowColor;
@property(nonatomic, assign) CGFloat lks_shadowOffsetWidth;
@property(nonatomic, assign) CGFloat lks_shadowOffsetHeight;

@end
