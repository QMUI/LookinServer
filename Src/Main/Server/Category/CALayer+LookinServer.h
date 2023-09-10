#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIView+LookinMobile.h
//  WeRead
//
//  Created by Li Kai on 2018/11/30.
//  Copyright © 2018 tencent. All rights reserved.
//

#import "LookinDefines.h"
#import "TargetConditionals.h"
#import <UIKit/UIKit.h>

@interface CALayer (LookinServer)

/// 如果 myView.layer == myLayer，则 myLayer.lks_hostView 会返回 myView
@property(nonatomic, readonly, weak) UIView *lks_hostView;

- (UIWindow *)lks_window;

- (CGRect)lks_frameInWindow:(UIWindow *)window;

@property(nonatomic, assign) BOOL lks_isLookinPrivateLayer;

/// 如果该属性为 YES，则该 layer 及所有下级 layers 均不会被转为 LookinDisplayItem
@property(nonatomic, assign) BOOL lks_avoidCapturing;

- (UIImage *)lks_groupScreenshotWithLowQuality:(BOOL)lowQuality;
/// 当没有 sublayers 时，该方法返回 nil
- (UIImage *)lks_soloScreenshotWithLowQuality:(BOOL)lowQuality;

/// 获取和该对象有关的对象的 Class 层级树
- (NSArray<NSArray<NSString *> *> *)lks_relatedClassChainList;

- (NSArray<NSString *> *)lks_selfRelation;

@property(nonatomic, strong) UIColor *lks_backgroundColor;
@property(nonatomic, strong) UIColor *lks_borderColor;
@property(nonatomic, strong) UIColor *lks_shadowColor;
@property(nonatomic, assign) CGFloat lks_shadowOffsetWidth;
@property(nonatomic, assign) CGFloat lks_shadowOffsetHeight;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
