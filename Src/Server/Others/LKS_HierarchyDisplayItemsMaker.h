//
//  LKS_HierarchyDisplayItemsMaker.h
//  LookinServer
//
//  Created by Li Kai on 2019/2/19.
//  https://lookin.work
//



#import "LookinDefines.h"

@class LookinDisplayItem;

@interface LKS_HierarchyDisplayItemsMaker : NSObject

/// @param hasScreenshots 是否包含 soloScreenshots 和 groupScreenshot 属性
/// @param hasAttrList 是否包含 attributesGroupList 属性
/// @param lowQuality screenshots 是否为低质量（当 hasScreenshots 为 NO 时，该属性无意义）
/// @param includedWindows 当传入的该参数有效时（即 count 大于 0），将仅抓取该数组指定的 window 的数据
/// @param excludedWindows 当 includedWindows 无效时，将不抓取 excludedWindows 指定的 window 的数据
+ (NSArray<LookinDisplayItem *> *)itemsWithScreenshots:(BOOL)hasScreenshots attrList:(BOOL)hasAttrList lowImageQuality:(BOOL)lowQuality includedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows;

@end
