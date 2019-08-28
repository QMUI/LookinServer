//
//  LookinDisplayItem.h
//  
//
//  
//

#import "TargetConditionals.h"
#import "LookinObject.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

@class LookinAttributesGroup, LookinIvarTrace, LookinPreviewItemLayer;

@interface LookinDisplayItem : NSObject <NSSecureCoding>

@property(nonatomic, copy) NSArray<LookinDisplayItem *> *subitems;

@property(nonatomic, assign) BOOL isHidden;

@property(nonatomic, assign) float alpha;

@property(nonatomic, assign) CGRect frame;

@property(nonatomic, assign) CGRect bounds;

/// 不存在 subitems 时，该属性的值为 nil
@property(nonatomic, strong) LookinImage *soloScreenshot;

@property(nonatomic, strong) LookinImage *groupScreenshot;

@property(nonatomic, strong) LookinObject *viewObject;
@property(nonatomic, strong) LookinObject *layerObject;
@property(nonatomic, strong) LookinObject *hostViewControllerObject;

/// attrGroups 列表
@property(nonatomic, copy) NSArray<LookinAttributesGroup *> *attributesGroupList;

// 如果当前 item 代表 UIWindow 且是 keyWindow，则该属性为 YES
@property(nonatomic, assign) BOOL representedAsKeyWindow;

#pragma mark - No Encode/Decode

/// 父节点
@property(nonatomic, weak) LookinDisplayItem *superItem;

/// 如果存在 viewObject 则返回 viewObject，否则返回 layerObject
- (LookinObject *)displayingObject;

- (NSString *)title;

/// 在 hierarchy 中的层级，比如顶层的 UIWindow.indentLevel 为 0，UIWindow 的 subitem 的 indentLevel 为 1
- (NSInteger)indentLevel;

/// className 以 “UI”、“CA” 等开头时认为是系统类，该属性将返回 YES
@property(nonatomic, assign, readonly) BOOL representedForSystemClass;

/**
 该项是否被折叠
 @note 假如自己没有被折叠，但是 superItem 被折叠了，则自己仍然不会被看到，但是 self.isExpanded 值仍然为 NO
 @note 如果 item 没有 subitems，则该值没有意义
 */
@property(nonatomic, assign) BOOL isExpanded;

/// 如果有 subitems，则该属性返回 YES，否则返回 NO
@property(nonatomic, assign, readonly) BOOL isExpandable;

/**
 是否能在 hierarchy panel 上被看到，假如有任意一层的父级元素的 isExpanded 为 NO，则 displayingInHierarchy 为 NO。如果所有父级元素的 isExpanded 均为 YES，则 displayingInHierarchy 为 YES
 */
@property(nonatomic, assign, readonly) BOOL displayingInHierarchy;

/**
 如果自身或任意一个上层元素的 isHidden 为 YES 或 alpha 为 0，则该属性返回 YES
 */
@property(nonatomic, assign, readonly) BOOL inHiddenHierarchy;

/// 返回 soloScreenshot 或 groupScreenshot
- (LookinImage *)appropriateScreenshot;

@property(nonatomic, strong) NSError *soloScreenshotSyncError;
@property(nonatomic, strong) NSError *groupScreenshotSyncError;

@property(nonatomic, assign) BOOL shouldEncodeScreenshot;

/// 如果该属性为 YES 则不会自动同步该 item 的图像（比如该 item 尺寸过大）
@property(nonatomic, assign) BOOL avoidSyncScreenshot;

@property(nonatomic, weak) LookinPreviewItemLayer *previewLayer;

/// 如果该值为 YES，则该 item 及所有子 item 均不会在 preview 中被显示出来，只能在 hierarchy 中选择。默认为 NO
@property(nonatomic, assign) BOOL noPreview;

/// 如果自身或某个上级元素的 noPreview 值为 YES，则该方法返回 YES
@property(nonatomic, assign, readonly) BOOL inNoPreviewHierarchy;

/// 当小于 0 时表示未被设置
@property(nonatomic, assign) NSInteger previewZIndex;

/**
 在当前 hierarchy 的最顶层的 item 的坐标系中，该 item 的 frame 值
 */
@property(nonatomic, assign, readonly) CGRect frameToRoot;

/// 遍历自身和所有上级元素
- (void)enumerateSelfAndAncestors:(void (^)(LookinDisplayItem *item, BOOL *stop))block;

- (void)enumerateAncestors:(void (^)(LookinDisplayItem *item, BOOL *stop))block;

/// 遍历自身后所有下级元素
- (void)enumerateSelfAndChildren:(void (^)(LookinDisplayItem *item))block;

@property(nonatomic, assign) BOOL preferToBeCollapsed;

@property(nonatomic, assign) BOOL isSelected;

@property(nonatomic, assign) BOOL isHovered;

- (BOOL)itemIsKindOfClassWithName:(NSString *)className;
- (BOOL)itemIsKindOfClassesWithNames:(NSSet<NSString *> *)classNames;

/// 根据 subItems 属性将 items 打平为一维数组
+ (NSArray<LookinDisplayItem *> *)flatItemsFromHierarchicalItems:(NSArray<LookinDisplayItem *> *)items;

/// 设置 indentLevel 属性
+ (void)setUpIndentLevelForFlatItems:(NSArray<LookinDisplayItem *> *)items;

@property(nonatomic, assign) BOOL hasDeterminedExpansion;

@end
