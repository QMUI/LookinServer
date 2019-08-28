//
//  LKS_LocalInspectViewController.h
//  LookinServer
//

//  Copyright © 2019 hughkli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKS_LocalInspectViewController : UIViewController

/// 用户点击了“退出”
@property(nonatomic, copy) void (^didSelectExit)(void);

- (void)highlightLayer:(CALayer *)layer;

@property(nonatomic, assign) BOOL showTitleButton;

- (void)clearContents;

- (void)startTitleButtonAnimIfNeeded;

@property(nonatomic, copy) NSArray<UIWindow *> *includedWindows;
@property(nonatomic, copy) NSArray<UIWindow *> *excludedWindows;

@property(nonatomic, weak) UIWindow *prevKeyWindow;

@end
