#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

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
/// @param readCustomInfo 是否读取 lookin_customDebugInfos，比如低版本的 Lookin 发请求时，就无需读取（因为 Lookin 解析不了、还可能出 Bug）
/// @param saveCustomSetter 是否要读取并保存用户给 attribute 配置的 custom setter
+ (NSArray<LookinDisplayItem *> *)itemsWithScreenshots:(BOOL)hasScreenshots attrList:(BOOL)hasAttrList lowImageQuality:(BOOL)lowQuality readCustomInfo:(BOOL)readCustomInfo saveCustomSetter:(BOOL)saveCustomSetter;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
