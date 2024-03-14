#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinDisplayItem.h
//  qmuidemo
//
//  Created by Li Kai on 2018/11/15.
//  Copyright © 2018 QMUI Team. All rights reserved.
//

#import "TargetConditionals.h"
#import "LookinObject.h"
#import "LookinDefines.h"
#import "LookinCustomDisplayItemInfo.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

@class LookinAttributesGroup, LookinIvarTrace, LookinPreviewItemLayer, LookinEventHandler, LKDisplayItemNode, LookinDisplayItem;

typedef NS_ENUM(NSUInteger, LookinDisplayItemImageEncodeType) {
    LookinDisplayItemImageEncodeTypeNone,   // 不进行 encode
    LookinDisplayItemImageEncodeTypeNSData, // 转换为 NSData
    LookinDisplayItemImageEncodeTypeImage   // 使用 NSImage / UIImage 自身的 encode 方法
};

typedef NS_ENUM(NSUInteger, LookinDoNotFetchScreenshotReason) {
    // can sync screenshot
    LookinFetchScreenshotPermitted,
    // layer is too large
    LookinDoNotFetchScreenshotForTooLarge,
    // refused by user config in LookinServer
    LookinDoNotFetchScreenshotForUserConfig
};


typedef NS_ENUM(NSUInteger, LookinDisplayItemProperty) {
    // 当初次设置 delegate 对象时，会立即以该值触发一次 displayItem:propertyDidChange:
    LookinDisplayItemProperty_None,
    LookinDisplayItemProperty_FrameToRoot,
    LookinDisplayItemProperty_DisplayingInHierarchy,
    LookinDisplayItemProperty_InHiddenHierarchy,
    LookinDisplayItemProperty_IsExpandable,
    LookinDisplayItemProperty_IsExpanded,
    LookinDisplayItemProperty_SoloScreenshot,
    LookinDisplayItemProperty_GroupScreenshot,
    LookinDisplayItemProperty_IsSelected,
    LookinDisplayItemProperty_IsHovered,
    LookinDisplayItemProperty_AvoidSyncScreenshot,
    LookinDisplayItemProperty_InNoPreviewHierarchy,
    LookinDisplayItemProperty_IsInSearch,
    LookinDisplayItemProperty_HighlightedSearchString,
};

@protocol LookinDisplayItemDelegate <NSObject>

- (void)displayItem:(LookinDisplayItem *)displayItem propertyDidChange:(LookinDisplayItemProperty)property;

@end

@interface LookinDisplayItem : NSObject <NSSecureCoding, NSCopying>

/// 当 customInfo 不为 nil 时，意思是该 DisplayItem 为 UserCustom 配置的。此时，Encode 属性中仅 subitems 和 customAttrGroupList 属性有意义，其它几乎所有属性都无意义
@property(nonatomic, strong) LookinCustomDisplayItemInfo *customInfo;

@property(nonatomic, copy) NSArray<LookinDisplayItem *> *subitems;

@property(nonatomic, assign) BOOL isHidden;

@property(nonatomic, assign) float alpha;

@property(nonatomic, assign) CGRect frame;

@property(nonatomic, assign) CGRect bounds;

/// 不存在 subitems 时，该属性的值为 nil
@property(nonatomic, strong) LookinImage *soloScreenshot;
/// 无论是否存在 subitems，该属性始终存在
@property(nonatomic, strong) LookinImage *groupScreenshot;

@property(nonatomic, strong) LookinObject *viewObject;
@property(nonatomic, strong) LookinObject *layerObject;
@property(nonatomic, strong) LookinObject *hostViewControllerObject;

/// attrGroups 列表
@property(nonatomic, copy) NSArray<LookinAttributesGroup *> *attributesGroupList;
/// 通过 lookin_customDebugInfos 返回的属性列表
@property(nonatomic, copy) NSArray<LookinAttributesGroup *> *customAttrGroupList;
/// attributesGroupList + customAttrGroupList
- (NSArray<LookinAttributesGroup *> *)queryAllAttrGroupList;

@property(nonatomic, copy) NSArray<LookinEventHandler *> *eventHandlers;

// 如果当前 item 代表 UIWindow 且是 keyWindow，则该属性为 YES
@property(nonatomic, assign) BOOL representedAsKeyWindow;


/// view 或 layer 的 backgroundColor，利用该属性来提前渲染 node 的背景色，使得用户感觉加载的快一点
/// 注意有一个缺点是，理论上应该像 screenshot 一样拆成 soloBackgroundColor 和 groupBackgroundColor，这里的 backgroundColor 实际上是 soloBackgroundColor，因此某些场景的显示会有瑕疵
@property(nonatomic, strong) LookinColor *backgroundColor;

/// 用户可以在 iOS 项目中添加 Lookin 自定义配置来显式地拒绝传输某些图层的图像，通常是屏蔽一些不重要的 View 以提升刷新速度。如果用户这么配置了，那么这个 shouldCaptureImage 就会被置为 NO
/// 默认为 YES
@property(nonatomic, assign) BOOL shouldCaptureImage;

/// 用户通过重写 lookin_customDebugInfos 而自定义的该实例的名字
/// 可能为 nil
@property(nonatomic, copy) NSString *customDisplayTitle;

/// 为 DanceUI SDK 预留的内部字段，用于文件跳转
/// 可能为 nil
@property(nonatomic, copy) NSString *danceuiSource;

#pragma mark - No Encode/Decode

@property(nonatomic, weak) id<LookinDisplayItemDelegate> previewItemDelegate;
@property(nonatomic, weak) id<LookinDisplayItemDelegate> rowViewDelegate;

/// 父节点
@property(nonatomic, weak) LookinDisplayItem *superItem;

/// 如果存在 viewObject 则返回 viewObject，否则返回 layerObject
- (LookinObject *)displayingObject;

/// 在 hierarchy 中的层级，比如顶层的 UIWindow.indentLevel 为 0，UIWindow 的 subitem 的 indentLevel 为 1
- (NSInteger)indentLevel;

/**
 该项是否被展开
 @note 假如自己没有被折叠，但是 superItem 被折叠了，则自己仍然不会被看到，但是 self.isExpanded 值仍然为 NO
 @note 如果 item 没有 subitems（也就是 isExpandable 为 NO），则该值没有意义。换句话说，在获取该值之前，必须先判断一下 isExpandable
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

@property(nonatomic, assign) LookinDisplayItemImageEncodeType screenshotEncodeType;

/// Whether to fetch screenshot and why. Default to LookinFetchScreenshotPermitted.
@property(nonatomic, assign) LookinDoNotFetchScreenshotReason doNotFetchScreenshotReason;

@property(nonatomic, weak) LookinPreviewItemLayer *previewLayer;

@property(nonatomic, weak) LKDisplayItemNode *previewNode;

/// 如果该值为 YES，则该 item 及所有子 item 均不会在 preview 中被显示出来，只能在 hierarchy 中选择。默认为 NO
@property(nonatomic, assign) BOOL noPreview;

/// 如果自身或某个上级元素的 noPreview 值为 YES，则该方法返回 YES
/// 注意：当 userCustom 为 YES 时，该属性也可能返回 YES
@property(nonatomic, assign, readonly) BOOL inNoPreviewHierarchy;

/// 当小于 0 时表示未被设置
@property(nonatomic, assign) NSInteger previewZIndex;

@property(nonatomic, assign) BOOL preferToBeCollapsed;

- (void)notifySelectionChangeToDelegates;
- (void)notifyHoverChangeToDelegates;

/// 根据 subItems 属性将 items 打平为一维数组
+ (NSArray<LookinDisplayItem *> *)flatItemsFromHierarchicalItems:(NSArray<LookinDisplayItem *> *)items;

@property(nonatomic, assign) BOOL hasDeterminedExpansion;

/// 设置当前是否处于搜索状态
@property(nonatomic, assign) BOOL isInSearch;
/// 因为搜索而应该被高亮的字符串
@property(nonatomic, copy) NSString *highlightedSearchString;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
