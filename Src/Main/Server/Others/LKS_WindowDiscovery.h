//
//  LKS_WindowDiscovery.h
//  LookinServer
//
//  Created by andysheng on 2023/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIWindow;
@interface LKS_WindowDiscovery : NSObject

/// combine different source of windows:
/// 1. [UIApplication sharedApplication].windows
/// 2. customWindow
/// 3. customView.window
@property (nonatomic, readonly) NSArray<UIWindow *> *windows;

+ (instancetype)sharedInstance;

- (void)addCustomWindow:(UIWindow *)window;

- (void)addCustomWindowWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
