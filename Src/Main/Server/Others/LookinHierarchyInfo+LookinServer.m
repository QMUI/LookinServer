//
//  LookinHierarchyInfo+LookinServer.m
//  LookinServer
//
//  Created by JH on 2024/11/5.
//

#import "LookinHierarchyInfo+LookinServer.h"
#import "LookinHierarchyInfo.h"
#import "LookinAttributesGroup.h"
#import "LookinDisplayItem.h"
#import "LookinAppInfo.h"
#import "NSArray+Lookin.h"
#import "NSString+Lookin.h"
#import "LKS_HierarchyDisplayItemsMaker.h"
#import "LKSConfigManager.h"
#import "LKS_CustomAttrSetterManager.h"
@implementation LookinHierarchyInfo (LookinServer)

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
@end
