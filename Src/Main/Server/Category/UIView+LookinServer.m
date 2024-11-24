#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIView+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/3/19.
//  https://lookin.work
//

#import "UIView+LookinServer.h"
#import <objc/runtime.h>
#import "LookinObject.h"
#import "LookinAutoLayoutConstraint.h"
#import "LookinServerDefines.h"
#import "LKS_MultiplatformAdapter.h"
#import "LookinAutoLayoutConstraint+LookinServer.h"
#import "NSWindow+LookinServer.h"
@implementation LookinView (LookinServer)

#if TARGET_OS_OSX
- (CGFloat)alpha {
    return self.alphaValue;
}
- (void)setContentCompressionResistancePriority:(NSLayoutPriority)priority
                                        forAxis:(NSLayoutConstraintOrientation)axis {
    [self setContentCompressionResistancePriority:priority forOrientation:axis];
}
- (void)setContentHuggingPriority:(NSLayoutPriority)priority
                          forAxis:(NSLayoutConstraintOrientation)axis {
    [self setContentHuggingPriority:priority forOrientation:axis];
}

- (float)contentHuggingPriorityForAxis:(NSLayoutConstraintOrientation)axis {
    return [self contentHuggingPriorityForOrientation:axis];
}

- (float)contentCompressionResistancePriorityForAxis:(NSLayoutConstraintOrientation)axis {
    return [self contentCompressionResistancePriorityForOrientation:axis];
}
- (NSArray<NSLayoutConstraint *> *)constraintsAffectingLayoutForAxis:(NSLayoutConstraintOrientation)orientation {
    return [self constraintsAffectingLayoutForOrientation:orientation];
}
#endif

- (LookinViewController *)lks_findHostViewController {
    LookinResponder *responder = [self nextResponder];
    if (!responder) {
        return nil;
    }
    if (![responder isKindOfClass:[LookinViewController class]]) {
        return nil;
    }
    LookinViewController *viewController = (LookinViewController *)responder;
    if (viewController.view != self) {
        return nil;
    }
    return viewController;
}

- (LookinView *)lks_subviewAtPoint:(CGPoint)point preferredClasses:(NSArray<Class> *)preferredClasses {
    BOOL isPreferredClassForSelf = [preferredClasses lookin_any:^BOOL(Class obj) {
        return [self isKindOfClass:obj];
    }];
    if (isPreferredClassForSelf) {
        return self;
    }
    
    LookinView *targetView = [self.subviews lookin_lastFiltered:^BOOL(__kindof LookinView *obj) {
        if (obj.hidden || obj.alpha <= 0.01) {
            return NO;
        }
        BOOL contains = CGRectContainsPoint(obj.frame, point);
        return contains;
    }];
    
    if (!targetView) {
        return self;
    }
    
    CGPoint newPoint = [targetView convertPoint:point fromView:self];
    targetView = [targetView lks_subviewAtPoint:newPoint preferredClasses:preferredClasses];
    return targetView;
}

- (CGSize)lks_bestSize {
#if TARGET_OS_IPHONE
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
#elif TARGET_OS_OSX
    if ([self isKindOfClass:[NSControl class]]) {
        return [((NSControl *)self) sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    } else {
        return self.fittingSize;
    }
#endif
}

- (CGFloat)lks_bestWidth {
    return self.lks_bestSize.width;
}

- (CGFloat)lks_bestHeight {
    return self.lks_bestSize.height;
}

- (void)setLks_isChildrenViewOfTabBar:(BOOL)lks_isChildrenViewOfTabBar {
    [self lookin_bindBOOL:lks_isChildrenViewOfTabBar forKey:@"lks_isChildrenViewOfTabBar"];
}
- (BOOL)lks_isChildrenViewOfTabBar {
    return [self lookin_getBindBOOLForKey:@"lks_isChildrenViewOfTabBar"];
}

- (void)setLks_verticalContentHuggingPriority:(float)lks_verticalContentHuggingPriority {
    [self setContentHuggingPriority:lks_verticalContentHuggingPriority forAxis:LookinLayoutConstraintAxisVertical];
}
- (float)lks_verticalContentHuggingPriority {
    return [self contentHuggingPriorityForAxis:LookinLayoutConstraintAxisVertical];
}

- (void)setLks_horizontalContentHuggingPriority:(float)lks_horizontalContentHuggingPriority {
    [self setContentHuggingPriority:lks_horizontalContentHuggingPriority forAxis:LookinLayoutConstraintAxisHorizontal];
}
- (float)lks_horizontalContentHuggingPriority {
    return [self contentHuggingPriorityForAxis:LookinLayoutConstraintAxisHorizontal];
}

- (void)setLks_verticalContentCompressionResistancePriority:(float)lks_verticalContentCompressionResistancePriority {
    [self setContentCompressionResistancePriority:lks_verticalContentCompressionResistancePriority forAxis:LookinLayoutConstraintAxisVertical];
}
- (float)lks_verticalContentCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:LookinLayoutConstraintAxisVertical];
}

- (void)setLks_horizontalContentCompressionResistancePriority:(float)lks_horizontalContentCompressionResistancePriority {
    [self setContentCompressionResistancePriority:lks_horizontalContentCompressionResistancePriority forAxis:LookinLayoutConstraintAxisHorizontal];
}
- (float)lks_horizontalContentCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:LookinLayoutConstraintAxisHorizontal];
}

+ (void)lks_rebuildGlobalInvolvedRawConstraints {
    [[LKS_MultiplatformAdapter allWindows] enumerateObjectsUsingBlock:^(__kindof LookinWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
#if TARGET_OS_IPHONE
        [self lks_removeInvolvedRawConstraintsForViewsRootedByView:window];
#elif TARGET_OS_OSX
        [self lks_removeInvolvedRawConstraintsForViewsRootedByView:window.lks_rootView];
#endif
    }];
    [[LKS_MultiplatformAdapter allWindows] enumerateObjectsUsingBlock:^(__kindof LookinWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
#if TARGET_OS_IPHONE
        [self lks_addInvolvedRawConstraintsForViewsRootedByView:window];
#elif TARGET_OS_OSX
        [self lks_addInvolvedRawConstraintsForViewsRootedByView:window.lks_rootView];
#endif
    }];
}

+ (void)lks_addInvolvedRawConstraintsForViewsRootedByView:(LookinView *)rootView {
    [rootView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        LookinView *firstView = constraint.firstItem;
        if ([firstView isKindOfClass:[LookinView class]] && ![firstView.lks_involvedRawConstraints containsObject:constraint]) {
            if (!firstView.lks_involvedRawConstraints) {
                firstView.lks_involvedRawConstraints = [NSMutableArray array];
            }
            [firstView.lks_involvedRawConstraints addObject:constraint];
        }
        
        LookinView *secondView = constraint.secondItem;
        if ([secondView isKindOfClass:[LookinView class]] && ![secondView.lks_involvedRawConstraints containsObject:constraint]) {
            if (!secondView.lks_involvedRawConstraints) {
                secondView.lks_involvedRawConstraints = [NSMutableArray array];
            }
            [secondView.lks_involvedRawConstraints addObject:constraint];
        }
    }];
    
    [rootView.subviews enumerateObjectsUsingBlock:^(__kindof LookinView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [self lks_addInvolvedRawConstraintsForViewsRootedByView:subview];
    }];
}

+ (void)lks_removeInvolvedRawConstraintsForViewsRootedByView:(LookinView *)rootView {
    [rootView.lks_involvedRawConstraints removeAllObjects];
    [rootView.subviews enumerateObjectsUsingBlock:^(__kindof LookinView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [self lks_removeInvolvedRawConstraintsForViewsRootedByView:subview];
    }];
}

- (void)setLks_involvedRawConstraints:(NSMutableArray<NSLayoutConstraint *> *)lks_involvedRawConstraints {
    [self lookin_bindObject:lks_involvedRawConstraints forKey:@"lks_involvedRawConstraints"];
}

- (NSMutableArray<NSLayoutConstraint *> *)lks_involvedRawConstraints {
    return [self lookin_getBindObjectForKey:@"lks_involvedRawConstraints"];
}

- (NSArray<LookinAutoLayoutConstraint *> *)lks_constraints {
    /**
     - lks_involvedRawConstraints 保存了牵扯到了 self 的所有的 constraints（包括未生效的，但不包括 inactive 的，整个产品逻辑都是直接忽略 inactive 的 constraints）
     - 通过 constraintsAffectingLayoutForAxis 可以拿到会影响 self 布局的所有已生效的 constraints（这里称之为 effectiveConstraints）
     - 很多情况下，一条 constraint 会出现在 effectiveConstraints 里但不会出现在 lks_involvedRawConstraints 里，比如：
        · UIWindow 拥有 minX, minY, width, height 四个 effectiveConstraints，但 lks_involvedRawConstraints 为空，因为它的 constraints 属性为空（这一点不知道为啥，但 Xcode Inspector 和 Reveal 确实也不会显示这四个 constraints）
        · 如果设置了 View1 的 center 和 superview 的 center 保持一致，则 superview 的 width 和 height 也会出现在 effectiveConstraints 里，但不会出现在 lks_involvedRawConstraints 里（这点可以理解，毕竟这种场景下 superview 的 width 和 height 确实会影响到 View1）
     */
    NSMutableArray<NSLayoutConstraint *> *effectiveConstraints = [NSMutableArray array];
    [effectiveConstraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:LookinLayoutConstraintAxisHorizontal]];
    [effectiveConstraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:LookinLayoutConstraintAxisVertical]];
    
    NSArray<LookinAutoLayoutConstraint *> *lookinConstraints = [self.lks_involvedRawConstraints lookin_map:^id(NSUInteger idx, __kindof NSLayoutConstraint *constraint) {
        BOOL isEffective = [effectiveConstraints containsObject:constraint];
        if ([constraint isActive]) {
            // trying to get firstItem or secondItem of an inactive constraint may cause dangling-pointer crash
            // https://github.com/QMUI/LookinServer/issues/86
            LookinConstraintItemType firstItemType = [self _lks_constraintItemTypeForItem:constraint.firstItem];
            LookinConstraintItemType secondItemType = [self _lks_constraintItemTypeForItem:constraint.secondItem];
            LookinAutoLayoutConstraint *lookinConstraint = [LookinAutoLayoutConstraint instanceFromNSConstraint:constraint isEffective:isEffective firstItemType:firstItemType secondItemType:secondItemType];
            return lookinConstraint;
        }
        return nil;
    }];
    return lookinConstraints.count ? lookinConstraints : nil;
}

- (LookinConstraintItemType)_lks_constraintItemTypeForItem:(id)item {
    if (!item) {
        return LookinConstraintItemTypeNil;
    }
    if (item == self) {
        return LookinConstraintItemTypeSelf;
    }
    if (item == self.superview) {
        return LookinConstraintItemTypeSuper;
    }
    
    // 在 runtime 时，这里会遇到的 UILayoutGuide 和 _UILayoutGuide 居然是 UIView 的子类，不知道是看错了还是有什么玄机，所以在判断是否是 UIView 之前要先判断这个
    if (@available(iOS 9.0, *)) {
        if ([item isKindOfClass:[LookinLayoutGuide class]]) {
            return LookinConstraintItemTypeLayoutGuide;
        }
    }
    
    
#if TARGET_OS_IPHONE
    NSString *className = NSStringFromClass([item class]);
    if ([className hasSuffix:@"_UILayoutGuide"]) {
        return LookinConstraintItemTypeLayoutGuide;
    }
#endif
    
    if ([item isKindOfClass:[LookinView class]]) {
        return LookinConstraintItemTypeView;
    }
    
    NSAssert(NO, @"");
    return LookinConstraintItemTypeUnknown;
}

#pragma mark - Screenshot

#if TARGET_OS_OSX
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
    
    NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    if (!rep) {
        return nil;
    }
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
    
    NSImage *image = [[NSImage alloc] initWithSize:rep.size];
    
    [image addRepresentation:rep];
    
    return image;
}

- (LookinImage *)lks_soloScreenshotWithLowQuality:(BOOL)lowQuality {
    if (!self.subviews.count) {
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
    
    if (self.subviews.count) {
        NSArray<NSView *> *subviews = [self.subviews copy];
        NSMutableArray<NSView *> *visibleSubviews = [NSMutableArray arrayWithCapacity:subviews.count];
        [subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!subview.hidden) {
                subview.hidden = YES;
                [visibleSubviews addObject:subview];
            }
        }];
        
        CGSize contextSize = self.frame.size;
        if (contextSize.width <= 0 || contextSize.height <= 0 || contextSize.width > 20000 || contextSize.height > 20000) {
            NSLog(@"LookinServer - Failed to capture screenshot. Invalid context size: %@ x %@", @(contextSize.width), @(contextSize.height));
            return nil;
        }

        NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
        if (!rep) {
            return nil;
        }
        [self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
        
        NSImage *image = [[NSImage alloc] initWithSize:rep.size];
        
        [image addRepresentation:rep];
        [visibleSubviews enumerateObjectsUsingBlock:^(NSView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            subview.hidden = NO;
        }];
        return image;
    }
    return nil;
}
#endif

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
