//
//  LookinDisplayInfo.h
//
//
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "LookinDefines.h"
#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

@class LookinDisplayItem, LookinAttributesGroup, LookinAppInfo;

@interface LookinHierarchyInfo : NSObject <NSSecureCoding>

#if TARGET_OS_IPHONE

+ (instancetype)staticInfo;

+ (instancetype)exportedInfo;

+ (instancetype)perspectiveInfoWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows;

+ (NSArray<NSString *> *)collapsedClassList;

#endif

/// 这里其实就是顶端的那几个 UIWindow
@property(nonatomic, copy) NSArray<LookinDisplayItem *> *displayItems;

@property(nonatomic, copy) NSDictionary<NSString *, id> *colorAlias;

@property(nonatomic, copy) NSArray<NSString *> *collapsedClassList;

@property(nonatomic, strong) LookinAppInfo *appInfo;

@end
