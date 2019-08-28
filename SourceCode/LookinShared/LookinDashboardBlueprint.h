//
//  LookinDashboardBlueprint.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LookinAttributeIdentifiers.h"

/**
 该对象定义了：
 - 哪些 GroupID, SectionID, AttrID 是合法的
 - 这些 ID 的父子顺序，比如 LookinAttrGroup_Frame 包含哪些 Section
 - 这些 ID 展示顺序（比如哪个 Group 在前、哪个 Group 在后）
 */
@interface LookinDashboardBlueprint : NSObject

+ (NSArray<NSNumber *> *)groupIDs;

+ (NSArray<NSNumber *> *)sectionIDsForGroupID:(LookinAttrGroupIdentifier)groupID;

+ (NSArray<NSNumber *> *)attrIDsForSectionID:(LookinAttrSectionIdentifier)sectionID;

@end
