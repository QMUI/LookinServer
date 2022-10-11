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

@implementation UIView (LookinServer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod([UIView class], @selector(initWithFrame:));
        Method newMethod = class_getInstanceMethod([UIView class], @selector(initWithFrame_lks:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getInstanceMethod([UIView class], @selector(initWithCoder:));
        newMethod = class_getInstanceMethod([UIView class], @selector(initWithCoder_lks:));
        method_exchangeImplementations(oriMethod, newMethod);
    });
}

- (instancetype)initWithFrame_lks:(CGRect)frame {
    UIView *view = [self initWithFrame_lks:frame];
    view.layer.lks_hostView = view;
    return view;
}

- (instancetype)initWithCoder_lks:(NSCoder *)coder {
    UIView *view = [self initWithCoder_lks:coder];
    view.layer.lks_hostView = view;
    return view;
}

- (void)setLks_hostViewController:(UIViewController *)lks_hostViewController {
    [self lookin_bindObjectWeakly:lks_hostViewController forKey:@"lks_hostViewController"];
}

- (UIViewController *)lks_hostViewController {
    return [self lookin_getBindObjectForKey:@"lks_hostViewController"];
}

- (UIView *)lks_subviewAtPoint:(CGPoint)point preferredClasses:(NSArray<Class> *)preferredClasses {
    BOOL isPreferredClassForSelf = [preferredClasses lookin_any:^BOOL(Class obj) {
        return [self isKindOfClass:obj];
    }];
    if (isPreferredClassForSelf) {
        return self;
    }
    
    UIView *targetView = [self.subviews lookin_lastFiltered:^BOOL(__kindof UIView *obj) {
        if (obj.layer.lks_isLookinPrivateLayer) {
            return NO;
        }
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
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
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
    [self setContentHuggingPriority:lks_verticalContentHuggingPriority forAxis:UILayoutConstraintAxisVertical];
}
- (float)lks_verticalContentHuggingPriority {
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
}

- (void)setLks_horizontalContentHuggingPriority:(float)lks_horizontalContentHuggingPriority {
    [self setContentHuggingPriority:lks_horizontalContentHuggingPriority forAxis:UILayoutConstraintAxisHorizontal];
}
- (float)lks_horizontalContentHuggingPriority {
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setLks_verticalContentCompressionResistancePriority:(float)lks_verticalContentCompressionResistancePriority {
    [self setContentCompressionResistancePriority:lks_verticalContentCompressionResistancePriority forAxis:UILayoutConstraintAxisVertical];
}
- (float)lks_verticalContentCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
}

- (void)setLks_horizontalContentCompressionResistancePriority:(float)lks_horizontalContentCompressionResistancePriority {
    [self setContentCompressionResistancePriority:lks_horizontalContentCompressionResistancePriority forAxis:UILayoutConstraintAxisHorizontal];
}
- (float)lks_horizontalContentCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
}

+ (void)lks_rebuildGlobalInvolvedRawConstraints {
    [[[UIApplication sharedApplication].windows copy] enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        [self lks_removeInvolvedRawConstraintsForViewsRootedByView:window];
    }];
    [[[UIApplication sharedApplication].windows copy] enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        [self lks_addInvolvedRawConstraintsForViewsRootedByView:window];
    }];
}

+ (void)lks_addInvolvedRawConstraintsForViewsRootedByView:(UIView *)rootView {
    [rootView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *firstView = constraint.firstItem;
        if ([firstView isKindOfClass:[UIView class]] && ![firstView.lks_involvedRawConstraints containsObject:constraint]) {
            if (!firstView.lks_involvedRawConstraints) {
                firstView.lks_involvedRawConstraints = [NSMutableArray array];
            }
            [firstView.lks_involvedRawConstraints addObject:constraint];
        }
        
        UIView *secondView = constraint.secondItem;
        if ([secondView isKindOfClass:[UIView class]] && ![secondView.lks_involvedRawConstraints containsObject:constraint]) {
            if (!secondView.lks_involvedRawConstraints) {
                secondView.lks_involvedRawConstraints = [NSMutableArray array];
            }
            [secondView.lks_involvedRawConstraints addObject:constraint];
        }
    }];
    
    [rootView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        [self lks_addInvolvedRawConstraintsForViewsRootedByView:subview];
    }];
}

+ (void)lks_removeInvolvedRawConstraintsForViewsRootedByView:(UIView *)rootView {
    [rootView.lks_involvedRawConstraints removeAllObjects];
    [rootView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
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
    [effectiveConstraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]];
    [effectiveConstraints addObjectsFromArray:[self constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]];
    
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
        if ([item isKindOfClass:[UILayoutGuide class]]) {
            return LookinConstraintItemTypeLayoutGuide;
        }
    }
    
    if ([[item lks_shortClassName] isEqualToString:@"_UILayoutGuide"]) {
        return LookinConstraintItemTypeLayoutGuide;
    }
    
    if ([item isKindOfClass:[UIView class]]) {
        return LookinConstraintItemTypeView;
    }
    
    NSAssert(NO, @"");
    return LookinConstraintItemTypeUnknown;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
