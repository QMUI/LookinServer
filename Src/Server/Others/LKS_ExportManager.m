//
//  LKS_ExportManager.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/13.
//  https://lookin.work
//

#import "LKS_ExportManager.h"
#import "UIViewController+LookinServer.h"
#import "LookinHierarchyInfo.h"
#import "LookinHierarchyFile.h"
#import "LookinAppInfo.h"
#import "LookinServerDefines.h"

@interface LKS_ExportManagerMaskView : UIView

@property(nonatomic, strong) UIView *tipsView;
@property(nonatomic, strong) UILabel *firstLabel;
@property(nonatomic, strong) UILabel *secondLabel;
@property(nonatomic, strong) UILabel *thirdLabel;

@end

@implementation LKS_ExportManagerMaskView

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
        self.firstLabel.text = LKS_Localized(@"Creating File…");
        self.firstLabel.textColor = [UIColor whiteColor];
        self.firstLabel.font = [UIFont boldSystemFontOfSize:14];
        self.firstLabel.textAlignment = NSTextAlignmentCenter;
        self.firstLabel.numberOfLines = 0;
        [self.tipsView addSubview:self.firstLabel];
        
        self.secondLabel = [UILabel new];
        self.secondLabel.text = LKS_Localized(@"May take 8 or more seconds according to the UI complexity.");
        self.secondLabel.textColor = [UIColor colorWithRed:173/255.0 green:180/255.0 blue:190/255.0 alpha:1];
        self.secondLabel.font = [UIFont systemFontOfSize:12];
        self.secondLabel.textAlignment = NSTextAlignmentLeft;
        self.secondLabel.numberOfLines = 0;
        [self.tipsView addSubview:self.secondLabel];
        
        self.thirdLabel = [UILabel new];
        self.thirdLabel.text = LKS_Localized(@"The file can be opend by Lookin.app in macOS.");
        self.thirdLabel.textColor = [UIColor colorWithRed:173/255.0 green:180/255.0 blue:190/255.0 alpha:1];
        self.thirdLabel.font = [UIFont systemFontOfSize:12];
        self.thirdLabel.textAlignment = NSTextAlignmentCenter;
        self.thirdLabel.numberOfLines = 0;
        [self.tipsView addSubview:self.thirdLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(8, 10, 8, 10);
    CGFloat maxLabelWidth = self.bounds.size.width * .8 - insets.left - insets.right;
    
    CGSize firstSize = [self.firstLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    CGSize secondSize = [self.secondLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    CGSize thirdSize = [self.thirdLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];

    CGFloat tipsWidth = MAX(MAX(firstSize.width, secondSize.width), thirdSize.width) + insets.left + insets.right;

    self.firstLabel.frame = CGRectMake(tipsWidth / 2.0 - firstSize.width / 2.0, insets.top, firstSize.width, firstSize.height);
    self.secondLabel.frame = CGRectMake(tipsWidth / 2.0 - secondSize.width / 2.0, CGRectGetMaxY(self.firstLabel.frame) + 10, secondSize.width, secondSize.height);
    self.thirdLabel.frame = CGRectMake(tipsWidth / 2.0 - thirdSize.width / 2.0, CGRectGetMaxY(self.secondLabel.frame) + 5, thirdSize.width, thirdSize.height);

    self.tipsView.frame = ({
        CGFloat height = CGRectGetMaxY(self.thirdLabel.frame) + insets.bottom;
        CGRectMake(self.bounds.size.width / 2.0 - tipsWidth / 2.0, self.bounds.size.height / 2.0 - height / 2.0, tipsWidth, height);
    });
}

@end

@interface LKS_ExportManager ()

#if TARGET_OS_TV
#else
@property(nonatomic, strong) UIDocumentInteractionController *documentController;
#endif

@property(nonatomic, strong) LKS_ExportManagerMaskView *maskView;

@end

@implementation LKS_ExportManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_ExportManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

#if TARGET_OS_TV
- (void)exportAndShare {
    NSAssert(NO, @"not supported");
}
#else
- (void)exportAndShare {
    
    UIViewController *visibleVc = [UIViewController lks_visibleViewController];
    if (!visibleVc) {
        NSLog(@"LookinServer - Failed to export because we didn't find any visible view controller.");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_WillExport" object:nil];
    
    if (!self.maskView) {
        self.maskView = [LKS_ExportManagerMaskView new];
    }
    [visibleVc.view.window addSubview:self.maskView];
    self.maskView.frame = visibleVc.view.window.bounds;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LookinHierarchyInfo *info = [LookinHierarchyInfo exportedInfo];
        LookinHierarchyFile *file = [LookinHierarchyFile new];
        file.serverVersion = info.serverVersion;
        file.hierarchyInfo = info;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:file];
        if (!data) {
            return;
        }
        
        NSString *fileName = ({
            NSString *timeString = ({
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMddHHmm"];
                [formatter stringFromDate:date];
            });
            NSString *iOSVersion = ({
                NSString *str = info.appInfo.osDescription;
                NSUInteger dotIdx = [str rangeOfString:@"."].location;
                if (dotIdx != NSNotFound) {
                    str = [str substringToIndex:dotIdx];
                }
                str;
            });
            [NSString stringWithFormat:@"%@_ios%@_%@.lookin", info.appInfo.appName, iOSVersion, timeString];
        });
        NSString *path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), fileName];
        [data writeToFile:path atomically:YES];
        
        [self.maskView removeFromSuperview];
        
        if (!self.documentController) {
            self.documentController = [UIDocumentInteractionController new];
        }
        self.documentController.URL = [NSURL fileURLWithPath:path];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 1, 1) inView:visibleVc.view animated:YES];
        } else {
            [self.documentController presentOpenInMenuFromRect:visibleVc.view.bounds inView:visibleVc.view animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_DidFinishExport" object:nil];
        
//        [self.documentController presentOptionsMenuFromRect:visibleVc.view.bounds inView:visibleVc.view animated:YES];
        
//        CFTimeInterval endTime = CACurrentMediaTime();
//        CFTimeInterval consumingTime = endTime - startTime;
//        NSLog(@"LookinServer - 导出 UI 结构耗时：%@", @(consumingTime));
    });
}
#endif

@end
