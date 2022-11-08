#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_PerspectiveManager.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//

#import "LKS_PerspectiveManager.h"



#import "LKS_PerspectiveViewController.h"
#import "UIViewController+LookinServer.h"
#import "LookinHierarchyInfo.h"
#import "LookinServerDefines.h"
#import "LKS_PerspectiveToolbarButtons.h"

@interface LKS_PerspectiveLoadingMaskView : UIView

@property(nonatomic, strong) UIView *tipsView;
@property(nonatomic, strong) UILabel *firstLabel;
@property(nonatomic, strong) UILabel *secondLabel;

@end

@implementation LKS_PerspectiveLoadingMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
        self.layer.lks_isLookinPrivateLayer = YES;
        self.layer.lks_avoidCapturing = YES;
        
        self.tipsView = [UIView new];
        self.tipsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.88];
        self.tipsView.layer.cornerRadius = 6;
        self.tipsView.layer.masksToBounds = YES;
        [self addSubview:self.tipsView];
        
        self.firstLabel = [UILabel new];
        self.firstLabel.text = LKS_Localized(@"Building…");
        self.firstLabel.textColor = [UIColor whiteColor];
        self.firstLabel.font = [UIFont boldSystemFontOfSize:14];
        self.firstLabel.textAlignment = NSTextAlignmentCenter;
        [self.tipsView addSubview:self.firstLabel];
        
        self.secondLabel = [UILabel new];
        self.secondLabel.numberOfLines = 0;
        self.secondLabel.textAlignment = NSTextAlignmentCenter;
        self.secondLabel.text =  LKS_Localized(@"May take 8 or more seconds according to the UI complexity.");
        self.secondLabel.textColor = [UIColor colorWithRed:173/255.0 green:180/255.0 blue:190/255.0 alpha:1];
        self.secondLabel.font = [UIFont systemFontOfSize:12];
        self.secondLabel.textAlignment = NSTextAlignmentLeft;
        [self.tipsView addSubview:self.secondLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 10, 8, 10);
    CGFloat maxLabelWidth = self.bounds.size.width * .8 - insets.left - insets.right;
    
    CGSize firstSize = [self.firstLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    CGSize secondSize = [self.secondLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    
    CGFloat tipsWidth = MAX(firstSize.width, secondSize.width) + insets.left + insets.right;
    
    self.firstLabel.frame = CGRectMake(tipsWidth / 2.0 - firstSize.width / 2.0, insets.top, firstSize.width, firstSize.height);
    self.secondLabel.frame = CGRectMake(tipsWidth / 2.0 - secondSize.width / 2.0, CGRectGetMaxY(self.firstLabel.frame) + 7, secondSize.width, secondSize.height);
    
    self.tipsView.frame = ({
        CGFloat height = CGRectGetMaxY(self.secondLabel.frame) + insets.bottom;
        CGRectMake(self.bounds.size.width / 2.0 - tipsWidth / 2.0, self.bounds.size.height / 2.0 - height / 2.0, tipsWidth, height);
    });
}

@end

@implementation LKS_PerspectiveContainerWindow

@end

@interface LKS_PerspectiveManager ()

@property(nonatomic, strong) LKS_PerspectiveLoadingMaskView *loadingView;

@property(nonatomic, weak) UIWindow *previousKeyWindow;

@property(nonatomic, strong) LKS_PerspectiveContainerWindow *contentWindow;

@property(nonatomic, strong) LKS_PerspectiveViewController *viewController;

@end

@implementation LKS_PerspectiveManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_PerspectiveManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)showWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows {
    UIViewController *visibleVc = [UIViewController lks_visibleViewController];
    if (!visibleVc) {
        NSLog(@"LookinServer - Failed to start inspecting in 3D because we didn't find any visible view controller.");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_WillEnter3D" object:nil];
    
    if (!self.loadingView) {
        self.loadingView = [LKS_PerspectiveLoadingMaskView new];
    }
    [visibleVc.view.window addSubview:self.loadingView];
    self.loadingView.frame = visibleVc.view.window.bounds;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LookinHierarchyInfo *info = [LookinHierarchyInfo perspectiveInfoWithIncludedWindows:includedWindows excludedWindows:excludedWindows];
        
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;

        self.contentWindow = [LKS_PerspectiveContainerWindow new];
        self.contentWindow.windowLevel = UIWindowLevelAlert - 2;
        self.contentWindow.backgroundColor = [UIColor clearColor];

        self.viewController = [[LKS_PerspectiveViewController alloc] initWithHierarchyInfo:info];
        self.contentWindow.rootViewController = self.viewController;

        self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
        [self.contentWindow makeKeyAndVisible];

        [self.viewController.closeButton addTarget:self action:@selector(_exit) forControlEvents:UIControlEventTouchUpInside];
    });
}

- (void)_exit {
    if (!self.contentWindow) {
        return;
    }
    
    if ([[UIApplication sharedApplication] keyWindow] == self.contentWindow) {
        if (self.previousKeyWindow.hidden) {
            [[UIApplication sharedApplication].delegate.window makeKeyWindow];
        } else {
            [self.previousKeyWindow makeKeyWindow];
        }
    }
    self.contentWindow.hidden = YES;
    self.contentWindow = nil;
    self.viewController = nil;
    self.previousKeyWindow = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_DidExit3D" object:nil];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
