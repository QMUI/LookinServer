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
#import "LKS_MultiplatformAdapter.h"

@implementation LookinViewController (LookinServer)

+ (nullable LookinViewController *)lks_visibleViewController {
#if TARGET_OS_IPHONE
    LookinViewController *rootViewController = [LKS_MultiplatformAdapter keyWindow].rootViewController;
    LookinViewController *visibleViewController = [rootViewController lks_visibleViewControllerIfExist];
    return visibleViewController;
#endif
    
#if TARGET_OS_OSX
    
    LookinViewController *rootViewController = [LKS_MultiplatformAdapter keyWindow].contentViewController;
    LookinViewController *visibleViewController = [rootViewController lks_visibleViewControllerIfExist];
    return visibleViewController;
#endif
}

- (LookinViewController *)lks_visibleViewControllerIfExist {
    
#if TARGET_OS_IPHONE
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
#endif
    
#if TARGET_OS_OSX
    if (self.presentedViewControllers) {
        for (NSViewController *presentedViewController in self.presentedViewControllers) {
            return [presentedViewController lks_visibleViewControllerIfExist];
        }
    }
    
    if (self.isViewLoaded && !self.view.hidden && self.view.alphaValue > 0.01) {
        return self;
    } else {
        return nil;
    }
#endif
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
