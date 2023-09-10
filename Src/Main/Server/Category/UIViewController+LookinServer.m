#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIViewController+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/4/22.
//  https://lookin.work
//

#import "UIViewController+LookinServer.h"
#import "UIView+LookinServer.h"
#import <objc/runtime.h>

@implementation UIViewController (LookinServer)

+ (nullable UIViewController *)lks_visibleViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *visibleViewController = [rootViewController lks_visibleViewControllerIfExist];
    return visibleViewController;
}

- (UIViewController *)lks_visibleViewControllerIfExist {
    
    if (self.presentedViewController) {
        return [self.presentedViewController lks_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController lks_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController lks_visibleViewControllerIfExist];
    }
    
    if (self.isViewLoaded && !self.view.hidden && self.view.alpha > 0.01) {
        return self;
    } else {
        return nil;
    }
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
