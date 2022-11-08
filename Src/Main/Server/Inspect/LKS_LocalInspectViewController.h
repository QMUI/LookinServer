#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_LocalInspectViewController.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/15.
//  https://lookin.work
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

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
