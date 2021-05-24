//
//  LKS_PerspectiveDataSource.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//

#import "LKS_PerspectiveDataSource.h"



#import "UIColor+LookinServer.h"
#import "LookinDisplayItem.h"
#import "LookinHierarchyInfo.h"
#import "LookinServerDefines.h"
#import "LKS_PerspectiveLayer.h"

@interface LKS_PerspectiveDataSource ()

@property(nonatomic, copy, readwrite) NSArray<LookinDisplayItem *> *flatItems;
@property(nonatomic, copy, readwrite) NSArray<LookinDisplayItem *> *displayingFlatItems;

/**
 key 是 rgba 字符串，value 是 alias 字符串数组，比如：
 
 @{
 @"(255, 255, 255, 1)": @[@"MyWhite", @"MainThemeWhite"],
 @"(255, 0, 0, 0.5)": @[@"BestRed", @"TransparentRed"]
 };
 
 */
@property(nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *colorToAliasMap;

@end

@implementation LKS_PerspectiveDataSource

- (instancetype)initWithHierarchyInfo:(LookinHierarchyInfo *)info {
    if (self = [self init]) {
        _rawHierarchyInfo = info;
        
//        [self _setUpColors];
        
        // 打平为二维数组
        self.flatItems = [LookinDisplayItem flatItemsFromHierarchicalItems:info.displayItems];
        
        // 设置 preferToBeCollapsed 属性
        NSSet<NSString *> *classesPreferredToCollapse = [NSSet setWithObjects:@"UILabel", @"UIPickerView", @"UIProgressView", @"UIActivityIndicatorView", @"UIAlertView", @"UIActionSheet", @"UISearchBar", @"UIButton", @"UITextView", @"UIDatePicker", @"UIPageControl", @"UISegmentedControl", @"UITextField", @"UISlider", @"UISwitch", @"UIVisualEffectView", @"UIImageView", @"WKCommonWebView", @"UITextEffectsWindow", @"LKS_LocalInspectContainerWindow", nil];
        if (info.collapsedClassList.count) {
            classesPreferredToCollapse = [classesPreferredToCollapse setByAddingObjectsFromArray:info.collapsedClassList];
        }
        // no preview
        NSSet<NSString *> *classesWithNoPreview = [NSSet setWithArray:@[@"UITextEffectsWindow", @"UIRemoteKeyboardWindow", @"LKS_LocalInspectContainerWindow"]];
        
        [self.flatItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj itemIsKindOfClassesWithNames:classesPreferredToCollapse]) {
                [obj enumerateSelfAndChildren:^(LookinDisplayItem *item) {
                    item.preferToBeCollapsed = YES;
                }];
            }
            
            if (obj.indentLevel == 0) {
                if ([obj itemIsKindOfClassesWithNames:classesWithNoPreview]) {
                    obj.noPreview = YES;
                }
            }
        }];
        
        // 设置展开和折叠
        LookinDisplayItem *shouldSelectedItem;
        [self _adjustExpansionWithPreferedSelectedItem:&shouldSelectedItem];
        
        // 设置选中
        if (!shouldSelectedItem) {
            shouldSelectedItem = self.flatItems.firstObject;
        }
        self.selectedItem = shouldSelectedItem;
    }
    return self;
}

- (NSInteger)numberOfRows {
    return self.displayingFlatItems.count;
}

- (LookinDisplayItem *)itemAtRow:(NSInteger)index {
    return [self.displayingFlatItems lookin_safeObjectAtIndex:index];
}

- (NSInteger)rowForItem:(LookinDisplayItem *)item {
    NSInteger row = [self.displayingFlatItems indexOfObject:item];
    return row;
}

- (void)setSelectedItem:(LookinDisplayItem *)selectedItem {
    if (_selectedItem == selectedItem) {
        return;
    }
    _selectedItem.isSelected = NO;
    _selectedItem = selectedItem;
    _selectedItem.isSelected = YES;
    
    if ([self.hierarchyView respondsToSelector:@selector(dataSourceDidChangeSelectedItem:)]) {
        [self.hierarchyView dataSourceDidChangeSelectedItem:self];
    }
    if ([self.perspectiveLayer respondsToSelector:@selector(dataSourceDidChangeSelectedItem:)]) {
        [self.perspectiveLayer dataSourceDidChangeSelectedItem:self];
    }
}

- (void)collapseItem:(LookinDisplayItem *)item {
    if (!item.isExpandable) {
        return;
    }
    if (!item.isExpanded) {
        return;
    }
    item.isExpanded = NO;
    [self _updateDisplayingFlatItems];
}

- (void)expandItem:(LookinDisplayItem *)item {
    if (!item.isExpandable) {
        return;
    }
    if (item.isExpanded) {
        return;
    }
    item.isExpanded = YES;
    [self _updateDisplayingFlatItems];
}

#pragma mark - Colors

- (NSArray<NSString *> *)aliasForColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    NSString *rgbaString = color.lks_rgbaString;
    NSArray<NSString *> *names = self.colorToAliasMap[rgbaString];
    return names;
}

//- (void)_setUpColors {
//    NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *colorToAliasMap = [NSMutableDictionary dictionary];
//
//    /**
//     hierarchyInfo.colorAlias 可以有三种结构：
//     1）key 是颜色别名，value 是 UIColor/UIColor。即 <NSString *, Color *>
//     2）key 是一组颜色的标题，value 是 NSDictionary，而这个 NSDictionary 的 key 是颜色别名，value 是 UIColor / UIColor。即 <NSString *, NSDictionary<NSString *, Color *> *>
//     3）以上两者混在一起
//     */
//    [self.rawHierarchyInfo.colorAlias enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull colorOrDict, BOOL * _Nonnull stop) {
//        if ([colorOrDict isKindOfClass:[UIColor class]]) {
//            NSString *colorDesc = [((UIColor *)colorOrDict) lks_rgbaString];
//            if (colorDesc) {
//                if (!colorToAliasMap[colorDesc]) {
//                    colorToAliasMap[colorDesc] = [NSMutableArray array];
//                }
//                [colorToAliasMap[colorDesc] addObject:key];
//            }
//
//        } else if ([colorOrDict isKindOfClass:[NSDictionary class]]) {
//            [((NSDictionary *)colorOrDict) enumerateKeysAndObjectsUsingBlock:^(NSString *colorAliaName, UIColor *colorObj, BOOL * _Nonnull stop) {
//                NSString *colorDesc = colorObj.lks_rgbaString;
//                if (colorDesc) {
//                    if (!colorToAliasMap[colorDesc]) {
//                        colorToAliasMap[colorDesc] = [NSMutableArray array];
//                    }
//                    [colorToAliasMap[colorDesc] addObject:colorAliaName];
//                }
//            }];
//
//        } else {
//            NSAssert(NO, @"");
//        }
//    }];
//    self.colorToAliasMap = colorToAliasMap;
//}

#pragma mark - Others

- (void)_adjustExpansionWithPreferedSelectedItem:(LookinDisplayItem **)selectedItem {
    [self.flatItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hasDeterminedExpansion = NO;
        
        if (!obj.isExpandable) {
            obj.hasDeterminedExpansion = YES;
            return;
        }
    }];
    
    LookinDisplayItem *keyWindowItem = [self.rawHierarchyInfo.displayItems lookin_firstFiltered:^BOOL(LookinDisplayItem *windowItem) {
        return windowItem.representedAsKeyWindow;
    }];
    if (!keyWindowItem) {
        keyWindowItem = self.rawHierarchyInfo.displayItems.firstObject;
    }
    [self.rawHierarchyInfo.displayItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull windowItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (windowItem == keyWindowItem) {
            return;
        }
        // 非 keyWindow 上的都折叠起来
        [[LookinDisplayItem flatItemsFromHierarchicalItems:@[windowItem]] enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.hasDeterminedExpansion) {
                return;
            }
            obj.isExpanded = NO;
            obj.hasDeterminedExpansion = YES;
        }];
    }];
    
    NSArray<LookinDisplayItem *> *UITransitionViewItems = [keyWindowItem.subitems lookin_filter:^BOOL(LookinDisplayItem *obj) {
        return [obj.title isEqualToString:@"UITransitionView"];
    }];
    [UITransitionViewItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.hasDeterminedExpansion) {
            return;
        }
        if (idx == (UITransitionViewItems.count - 1)) {
            // 展开最后一个 UITransitionView
            obj.isExpanded = YES;
        } else {
            // 折叠前几个 UITransitionView
            obj.isExpanded = NO;
        }
        obj.hasDeterminedExpansion = YES;
    }];
    
    NSMutableArray<LookinDisplayItem *> *viewControllerItems = [NSMutableArray array];
    [[LookinDisplayItem flatItemsFromHierarchicalItems:@[keyWindowItem]] enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!!obj.hostViewControllerObject) {
            [viewControllerItems addObject:obj];
            return;
        }
        if (obj.hasDeterminedExpansion) {
            return;
        }
        if (obj.inNoPreviewHierarchy || obj.preferToBeCollapsed || obj.inHiddenHierarchy) {
            // 把 noPreview 和 UIButton 之类常用控件叠起来
            obj.isExpanded = NO;
            obj.hasDeterminedExpansion = YES;
            return;
        }
        if ([obj itemIsKindOfClassesWithNames:[NSSet setWithObjects:@"UINavigationBar", @"UITabBar", nil]]) {
            // 把 NavigationBar 和 TabBar 折叠起来
            [obj enumerateSelfAndChildren:^(LookinDisplayItem *item) {
                if (item.hasDeterminedExpansion) {
                    return;
                }
                item.isExpanded = NO;
                item.hasDeterminedExpansion = YES;
            }];
            return;
        }
    }];
    
    // 从 viewController 开始算向 leaf 多推 3 层
    [viewControllerItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LookinDisplayItem * _Nonnull viewControllerItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [viewControllerItem enumerateAncestors:^(LookinDisplayItem *item, BOOL *stop) {
            // 把 viewController 的 ancestors 都展开
            if (item.hasDeterminedExpansion) {
                return;
            }
            item.isExpanded = YES;
            item.hasDeterminedExpansion = YES;
        }];
        
        BOOL hasTableOrCollectionView = [viewControllerItem.subitems.firstObject itemIsKindOfClassesWithNames:[NSSet setWithObjects:@"UITableView", @"UICollectionView", nil]];
        // 如果是那种典型的 UITableView 或 UICollectionView 的话，则向 leaf 方向推进 2 层（这样就可以让 cell 恰好露出来而不露出来 cell 的 contentView），否则就推 3 层
        NSUInteger indentsForward = hasTableOrCollectionView ? 2 : 3;
        
        [viewControllerItem enumerateSelfAndChildren:^(LookinDisplayItem *item) {
            if (item.hasDeterminedExpansion) {
                return;
            }
            // 向 leaf 方向推 2 或 3 层
            if (item.indentLevel < viewControllerItem.indentLevel + indentsForward) {
                item.isExpanded = YES;
                item.hasDeterminedExpansion = YES;
            }
        }];
    }];
    
    // 剩下未处理的都折叠
    [self.flatItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.hasDeterminedExpansion) {
            return;
        }
        obj.isExpanded = NO;
    }];
    
    if (selectedItem) {
        *selectedItem = viewControllerItems.lastObject;
    }
    
    [self _updateDisplayingFlatItems];
}

- (void)_updateDisplayingFlatItems {
    __block NSInteger maxIndentationLevel = 0;
    NSMutableArray<LookinDisplayItem *> *displayingItems = [NSMutableArray array];
    [self.flatItems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.displayingInHierarchy) {
            maxIndentationLevel = MAX(maxIndentationLevel, obj.indentLevel);
            [displayingItems addObject:obj];
        }
    }];
    self.displayingFlatItems = displayingItems;
    
    if ([self.hierarchyView respondsToSelector:@selector(dataSourceDidChangeDisplayItems:)]) {
        [self.hierarchyView dataSourceDidChangeDisplayItems:self];
    }
    if ([self.perspectiveLayer respondsToSelector:@selector(dataSourceDidChangeDisplayItems:)]) {
        [self.perspectiveLayer dataSourceDidChangeDisplayItems:self];
    }
}

@end
