#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIView+LookinMobile.h
//  WeRead
//
//  Created by Li Kai on 2018/11/30.
//  Copyright © 2018 tencent. All rights reserved.
//

#import "LookinDefines.h"

@interface CALayer (LookinServer)

/// 如果 myView.layer == myLayer，则 myLayer.lks_hostView 会返回 myView
@property(nonatomic, readonly, weak) LookinView *lks_hostView;

- (LookinWindow *)lks_window;

- (CGRect)lks_frameInWindow:(LookinWindow *)window;

- (LookinImage *)lks_groupScreenshotWithLowQuality:(BOOL)lowQuality;
/// 当没有 sublayers 时，该方法返回 nil
- (LookinImage *)lks_soloScreenshotWithLowQuality:(BOOL)lowQuality;

/// 获取和该对象有关的对象的 Class 层级树
- (NSArray<NSArray<NSString *> *> *)lks_relatedClassChainList;

- (NSArray<NSString *> *)lks_selfRelation;

@property(nonatomic, strong) LookinColor *lks_backgroundColor;
@property(nonatomic, strong) LookinColor *lks_borderColor;
@property(nonatomic, strong) LookinColor *lks_shadowColor;
@property(nonatomic, assign) CGFloat lks_shadowOffsetWidth;
@property(nonatomic, assign) CGFloat lks_shadowOffsetHeight;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
