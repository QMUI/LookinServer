#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_LocalInspectManager.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/8.
//  https://lookin.work
//

#import "LKS_LocalInspectManager.h"
#import "LKS_ConnectionManager.h"
#import "LKS_TraceManager.h"
#import "LKS_LocalInspectViewController.h"

@implementation LKS_LocalInspectContainerWindow

@end

@interface LKS_LocalInspectManager ()

@property(nonatomic, weak) UIWindow *previousKeyWindow;

@property(nonatomic, strong) LKS_LocalInspectContainerWindow *inspectorWindow;

@property(nonatomic, strong) LKS_LocalInspectViewController *viewController;

@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property(nonatomic, assign) BOOL isInspecting;

@property(nonatomic, copy) NSArray<UIWindow *> *includedWindows;

@end

@implementation LKS_LocalInspectManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_LocalInspectManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)startLocalInspectWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows {
    NSLog(@"LookinServer - Will start inspecting in 2D");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_WillEnter2D" object:nil];
    
    self.isInspecting = YES;

    [[LKS_TraceManager sharedInstance] reload];

    [self _setupWindowIfNeeded];
    self.viewController.showTitleButton = YES;
    self.inspectorWindow.userInteractionEnabled = YES;
    [self.viewController clearContents];
    self.viewController.prevKeyWindow = self.previousKeyWindow;
    self.viewController.includedWindows = includedWindows;
    self.viewController.excludedWindows = excludedWindows;
    [self.viewController startTitleButtonAnimIfNeeded];
}

- (void)_endLocalInspect {
    self.isInspecting = NO;
    
    self.viewController.showTitleButton = NO;
    self.viewController.includedWindows = nil;
    self.viewController.excludedWindows = nil;
    [self _removeWindowIfNeeded];
    self.inspectorWindow.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_DidExit2D" object:nil];
    NSLog(@"LookinServer - Did end inspecting in 2D");
}

- (void)_setupWindowIfNeeded {
    if (!self.inspectorWindow) {
        self.inspectorWindow = [LKS_LocalInspectContainerWindow new];
        self.inspectorWindow.windowLevel = UIWindowLevelAlert - 1;
        self.inspectorWindow.backgroundColor = [UIColor clearColor];
    }
    if (!self.viewController) {
        self.viewController = [LKS_LocalInspectViewController new];
        __weak __typeof(self)weakSelf = self;
        self.viewController.didSelectExit = ^{
            [weakSelf _endLocalInspect];
        };
        self.inspectorWindow.rootViewController = self.viewController;
    }
    if (!self.inspectorWindow.hidden) {
        return;
    }
    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    self.viewController.prevKeyWindow = self.previousKeyWindow;
    [self.inspectorWindow makeKeyAndVisible];
}

- (void)_removeWindowIfNeeded {
    if (!self.inspectorWindow || self.inspectorWindow.hidden) {
        return;
    }
    
    if ([[UIApplication sharedApplication] keyWindow] == self.inspectorWindow) {
        if (self.previousKeyWindow.hidden) {
            ///TODO 到底该用 keyWindow 还是 delegate.window
            [[UIApplication sharedApplication].delegate.window makeKeyWindow];
        } else {
            [self.previousKeyWindow makeKeyWindow];
        }
    }
    self.inspectorWindow.hidden = YES;
    self.previousKeyWindow = nil;
    self.viewController.prevKeyWindow = nil;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
