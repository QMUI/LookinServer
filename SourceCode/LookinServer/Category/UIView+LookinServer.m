//
//  UIView+LookinServer.m
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "UIView+LookinServer.h"
#import <objc/runtime.h>

@implementation UIView (LookinServer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod([self class], @selector(initWithFrame:));
        Method newMethod = class_getInstanceMethod([self class], @selector(lks_initWithFrame:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getInstanceMethod([self class], @selector(initWithCoder:));
        newMethod = class_getInstanceMethod([self class], @selector(lks_initWithCoder:));
        method_exchangeImplementations(oriMethod, newMethod);
    });
}

- (instancetype)lks_initWithFrame:(CGRect)frame {
    UIView *view = [self lks_initWithFrame:frame];
    view.layer.lks_hostView = view;
    return view;
}

- (instancetype)lks_initWithCoder:(NSCoder *)coder {
    UIView *view = [self lks_initWithCoder:coder];
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

@end
