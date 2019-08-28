//
//  UIView+LookinServer.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LookinServer)

@property(nonatomic, weak) UIViewController *lks_hostViewController;

/// 是否是 UITabBar 的 childrenView，如果是的话，则截图时需要强制使用 renderInContext: 的方式而非 drawViewHierarchyInRect:afterScreenUpdates: 否则在 iOS 13 上获取到的图像是空的不知道为什么
@property(nonatomic, assign) BOOL lks_isChildrenViewOfTabBar;

/// point 是相对于 receiver 自身的坐标系
- (UIView *)lks_subviewAtPoint:(CGPoint)point preferredClasses:(NSArray<Class> *)preferredClasses;

- (CGFloat)lks_bestWidth;
- (CGFloat)lks_bestHeight;
- (CGSize)lks_bestSize;

@end
