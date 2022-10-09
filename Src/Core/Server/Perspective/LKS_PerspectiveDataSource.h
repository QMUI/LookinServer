//
//  LKS_PerspectiveDataSource.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//



#import "LookinDefines.h"

@class LookinHierarchyInfo, LookinDisplayItem, LKS_PerspectiveDataSource;

@protocol LKS_PerspectiveDataSourceDelegate <NSObject>

@optional

- (void)dataSourceDidChangeSelectedItem:(LKS_PerspectiveDataSource *)dataSource;

- (void)dataSourceDidChangeDisplayItems:(LKS_PerspectiveDataSource *)dataSource;

- (void)dataSourceDidChangeNoPreview:(LKS_PerspectiveDataSource *)dataSource;

@end

@interface LKS_PerspectiveDataSource : NSObject

@property(nonatomic, weak) id<LKS_PerspectiveDataSourceDelegate> perspectiveLayer;
@property(nonatomic, weak) id<LKS_PerspectiveDataSourceDelegate> hierarchyView;

- (instancetype)initWithHierarchyInfo:(LookinHierarchyInfo *)info;

/// 一维数组，包含所有 hierarchy 树中可见和不可见的 displayItems
@property(nonatomic, copy, readonly) NSArray<LookinDisplayItem *> *flatItems;

/// 一维数组，只包括在 hierarchy 树中可见的 displayItems
@property(nonatomic, copy, readonly) NSArray<LookinDisplayItem *> *displayingFlatItems;

/// 当前应该被显示的 rows 行数
- (NSInteger)numberOfRows;

/// 获取指定行的 item
- (LookinDisplayItem *)itemAtRow:(NSInteger)index;

/// 获取指定 item 的 row，可能为 NSNotFound
- (NSInteger)rowForItem:(LookinDisplayItem *)item;

/// 当前选中的 item
@property(nonatomic, weak) LookinDisplayItem *selectedItem;

/// 将 item 折叠起来，如果该 item 没有 subitems 或已经被折叠，则该方法不起任何作用
- (void)collapseItem:(LookinDisplayItem *)item;

/// 将 item 展开，如果该 item 没有 subitems 或已经被展开，则该方法不起任何作用
- (void)expandItem:(LookinDisplayItem *)item;

/// 某个颜色的业务别名，如果不存在则返回 nil
- (NSArray<NSString *> *)aliasForColor:(UIColor *)color;

@property(nonatomic, strong, readonly) LookinHierarchyInfo *rawHierarchyInfo;

@end
