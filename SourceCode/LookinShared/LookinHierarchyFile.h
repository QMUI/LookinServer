//
//  LookinHierarchyFile.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinHierarchyInfo;

@interface LookinHierarchyFile : NSObject <NSSecureCoding>

@property(nonatomic, strong) LookinHierarchyInfo *hierarchyInfo;

@property(nonatomic, copy) NSDictionary<NSNumber *, NSData *> *soloScreenshots;
@property(nonatomic, copy) NSDictionary<NSNumber *, NSData *> *groupScreenshots;

@end
