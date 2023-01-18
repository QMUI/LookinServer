#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinDisplayInfo.h
//  WeRead
//
//  Created by Li Kai on 2018/10/22.
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

@interface LookinHierarchyInfo : NSObject <NSSecureCoding, NSCopying>

#if TARGET_OS_IPHONE

+ (instancetype)staticInfo;

+ (instancetype)exportedInfo;

+ (instancetype)perspectiveInfoWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows;

#endif

/// 这里其实就是顶端的那几个 UIWindow
@property(nonatomic, copy) NSArray<LookinDisplayItem *> *displayItems;

@property(nonatomic, copy) NSDictionary<NSString *, id> *colorAlias;

@property(nonatomic, copy) NSArray<NSString *> *collapsedClassList;

@property(nonatomic, strong) LookinAppInfo *appInfo;

/// 标记该 LookinServer 是通过什么方式安装的，0:未知，1:CocoaPods，2:手动，3:源代码，4:断点
@property(nonatomic, assign) int serverVersion;

@property(nonatomic, assign) int serverSetupType;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
