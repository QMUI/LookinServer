//
//  UIView+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/3/19.
//  https://lookin.work
//

#import "LookinDefines.h"
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

@property(nonatomic, assign) float lks_horizontalContentHuggingPriority;
@property(nonatomic, assign) float lks_verticalContentHuggingPriority;

@property(nonatomic, assign) float lks_horizontalContentCompressionResistancePriority;
@property(nonatomic, assign) float lks_verticalContentCompressionResistancePriority;

/// 遍历全局的 view 并给他们设置 lks_involvedRawConstraints 属性
+ (void)lks_rebuildGlobalInvolvedRawConstraints;
/// 该属性保存了牵扯到当前 view 的所有 constraints，包括那些没有生效的
@property(nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *lks_involvedRawConstraints;

- (NSArray<NSDictionary<NSString *, id> *> *)lks_constraints;

@end
