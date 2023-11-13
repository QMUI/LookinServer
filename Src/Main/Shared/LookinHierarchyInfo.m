#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinDisplayInfo.m
//  WeRead
//
//  Created by Li Kai on 2018/10/22.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <objc/runtime.h>
#import "LookinHierarchyInfo.h"
#import "LookinAttributesGroup.h"
#import "LookinDisplayItem.h"
#import "LookinAppInfo.h"
#import "NSArray+Lookin.h"
#import "NSString+Lookin.h"

#if TARGET_OS_IPHONE
#import "LKS_HierarchyDisplayItemsMaker.h"
#import "LKSConfigManager.h"
#import "LKS_CustomAttrSetterManager.h"
#endif

@implementation LookinHierarchyInfo

#if TARGET_OS_IPHONE

+ (instancetype)staticInfoWithLookinVersion:(NSString *)version {
    BOOL readCustomInfo = NO;
    // Client 1.0.4 开始支持 customInfo
    if (version && [version lookin_numbericOSVersion] >= 10004) {
        readCustomInfo = YES;
    }
    
    [[LKS_CustomAttrSetterManager sharedInstance] removeAll];
    
    LookinHierarchyInfo *info = [LookinHierarchyInfo new];
    info.serverVersion = LOOKIN_SERVER_VERSION;
    info.displayItems = [LKS_HierarchyDisplayItemsMaker itemsWithScreenshots:NO attrList:NO lowImageQuality:NO readCustomInfo:readCustomInfo saveCustomSetter:YES];
    info.appInfo = [LookinAppInfo currentInfoWithScreenshot:NO icon:YES localIdentifiers:nil];
    info.collapsedClassList = [LKSConfigManager collapsedClassList];
    info.colorAlias = [LKSConfigManager colorAlias];
    return info;
}

+ (instancetype)exportedInfo {
    LookinHierarchyInfo *info = [LookinHierarchyInfo new];
    info.serverVersion = LOOKIN_SERVER_VERSION;
    info.displayItems = [LKS_HierarchyDisplayItemsMaker itemsWithScreenshots:YES attrList:YES lowImageQuality:YES readCustomInfo:YES saveCustomSetter:NO];
    info.appInfo = [LookinAppInfo currentInfoWithScreenshot:NO icon:YES localIdentifiers:nil];
    info.collapsedClassList = [LKSConfigManager collapsedClassList];
    info.colorAlias = [LKSConfigManager colorAlias];
    return info;
}

#endif

#pragma mark - <NSSecureCoding>

static NSString * const LookinHierarchyInfoCodingKey_DisplayItems = @"1";
static NSString * const LookinHierarchyInfoCodingKey_AppInfo = @"2";
static NSString * const LookinHierarchyInfoCodingKey_ColorAlias = @"3";
static NSString * const LookinHierarchyInfoCodingKey_CollapsedClassList = @"4";

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.displayItems forKey:LookinHierarchyInfoCodingKey_DisplayItems];
    [aCoder encodeObject:self.colorAlias forKey:LookinHierarchyInfoCodingKey_ColorAlias];
    [aCoder encodeObject:self.collapsedClassList forKey:LookinHierarchyInfoCodingKey_CollapsedClassList];
    [aCoder encodeObject:self.appInfo forKey:LookinHierarchyInfoCodingKey_AppInfo];
    [aCoder encodeInt:self.serverVersion forKey:@"serverVersion"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.displayItems = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_DisplayItems];
        self.colorAlias = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_ColorAlias];
        self.collapsedClassList = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_CollapsedClassList];
        self.appInfo = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_AppInfo];
        self.serverVersion = [aDecoder decodeIntForKey:@"serverVersion"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    LookinHierarchyInfo *newAppInfo = [[LookinHierarchyInfo allocWithZone:zone] init];
    newAppInfo.serverVersion = self.serverVersion;
    newAppInfo.appInfo = self.appInfo.copy;
    newAppInfo.collapsedClassList = self.collapsedClassList;
    newAppInfo.colorAlias = self.colorAlias;
    newAppInfo.displayItems = [self.displayItems lookin_map:^id(NSUInteger idx, LookinDisplayItem *oldItem) {
        return oldItem.copy;
    }];
    
    return newAppInfo;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
