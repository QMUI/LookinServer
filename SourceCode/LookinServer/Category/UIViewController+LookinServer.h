//
//  UIViewController+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/4/22.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <UIKit/UIKit.h>

@interface UIViewController (LookinServer)

+ (UIViewController *)lks_visibleViewController;

@end

#endif
