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

#if TARGET_OS_IPHONE
#import "LKS_HierarchyDisplayItemsMaker.h"
#endif

@implementation LookinHierarchyInfo

#if TARGET_OS_IPHONE

+ (Class)configClass {
    static dispatch_once_t onceToken;
    static Class configClass = NULL;
    dispatch_once(&onceToken,^{
        NSString *rawName = @"LookinConfig";
        
        configClass = NSClassFromString(rawName);
        if (!configClass) {
            int numberOfClasses = objc_getClassList(NULL, 0);
            if (numberOfClasses > 0) {
                Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
                numberOfClasses = objc_getClassList(classes, numberOfClasses);
                for (int i = 0; i < numberOfClasses; i++) {
                    Class class = classes[i];
                    if ([NSStringFromClass(class) hasSuffix:@"LookinConfig"]) {
                        configClass = class;
                        break;
                    }
                }
                free(classes);
            }
        }
    });
    return configClass;
}

+ (instancetype)staticInfo {
    LookinHierarchyInfo *info = [LookinHierarchyInfo new];
    info.serverVersion = LOOKIN_SERVER_VERSION;
    info.displayItems = [LKS_HierarchyDisplayItemsMaker itemsWithScreenshots:NO attrList:NO lowImageQuality:NO includedWindows:nil excludedWindows:nil];
    info.appInfo = [LookinAppInfo currentInfoWithScreenshot:NO icon:YES localIdentifiers:nil];
    info.collapsedClassList = [self collapsedClassList];
    info.colorAlias = [self colorAlias];
    info.serverSetupType = LOOKIN_SERVER_SETUP_TYPE;
    return info;
}

+ (instancetype)exportedInfo {
    LookinHierarchyInfo *info = [LookinHierarchyInfo new];
    info.serverVersion = LOOKIN_SERVER_VERSION;
    info.displayItems = [LKS_HierarchyDisplayItemsMaker itemsWithScreenshots:YES attrList:YES lowImageQuality:YES includedWindows:nil excludedWindows:nil];
    info.appInfo = [LookinAppInfo currentInfoWithScreenshot:NO icon:YES localIdentifiers:nil];
    info.collapsedClassList = [self collapsedClassList];
    info.colorAlias = [self colorAlias];
    info.serverSetupType = LOOKIN_SERVER_SETUP_TYPE;
    return info;
}

+ (instancetype)perspectiveInfoWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows {
    LookinHierarchyInfo *info = [LookinHierarchyInfo new];
    info.serverVersion = LOOKIN_SERVER_VERSION;
    info.displayItems = [LKS_HierarchyDisplayItemsMaker itemsWithScreenshots:YES attrList:YES lowImageQuality:NO includedWindows:includedWindows excludedWindows:excludedWindows];
    info.appInfo = [LookinAppInfo currentInfoWithScreenshot:NO icon:YES localIdentifiers:nil];
    info.collapsedClassList = [self collapsedClassList];
    info.colorAlias = [self colorAlias];
    info.serverSetupType = LOOKIN_SERVER_SETUP_TYPE;
    return info;
}

+ (NSArray<NSString *> *)collapsedClassList {
    Class configClass = [self configClass];
    if (!configClass) {
        return nil;
    }
    SEL selector = NSSelectorFromString(@"collapsedClasses");
    if (![configClass respondsToSelector:selector]) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[configClass methodSignatureForSelector:selector]];
    [invocation setTarget:configClass];
    [invocation setSelector:selector];
    [invocation invoke];
    void *arrayValue;
    [invocation getReturnValue:&arrayValue];
    id classList = (__bridge id)(arrayValue);
    
    if ([classList isKindOfClass:[NSArray class]]) {
        NSArray *validClassList = [((NSArray *)classList) lookin_filter:^BOOL(id obj) {
            return [obj isKindOfClass:[NSString class]];
        }];
        return [validClassList copy];
    }
    return nil;
}

+ (NSDictionary<NSString *, UIColor *> *)colorAlias {
    Class configClass = [self configClass];
    if (!configClass) {
        return nil;
    }
    SEL selector = NSSelectorFromString(@"colors");
    if (![configClass respondsToSelector:selector]) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[configClass methodSignatureForSelector:selector]];
    [invocation setTarget:configClass];
    [invocation setSelector:selector];
    [invocation invoke];
    void *dictValue;
    [invocation getReturnValue:&dictValue];
    id colorAlias = (__bridge id)(dictValue);
    
    if ([colorAlias isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *validDictionary = [NSMutableDictionary dictionary];
        [(NSDictionary *)colorAlias enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:[NSString class]]) {
                if ([obj isKindOfClass:[UIColor class]]) {
                    [validDictionary setObject:obj forKey:key];
                    
                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                    __block BOOL isValidSubDict = YES;
                    [((NSDictionary *)obj) enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull subKey, id  _Nonnull subObj, BOOL * _Nonnull stop) {
                        if (![subKey isKindOfClass:[NSString class]] || ![subObj isKindOfClass:[UIColor class]]) {
                            isValidSubDict = NO;
                            *stop = YES;
                        }
                    }];
                    if (isValidSubDict) {
                        [validDictionary setObject:obj forKey:key];
                    }
                }
            }
        }];
        return [validDictionary copy];
    }
    return nil;
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
    [aCoder encodeInt:self.serverSetupType forKey:@"serverSetupType"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.displayItems = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_DisplayItems];
        self.colorAlias = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_ColorAlias];
        self.collapsedClassList = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_CollapsedClassList];
        self.appInfo = [aDecoder decodeObjectForKey:LookinHierarchyInfoCodingKey_AppInfo];
        self.serverVersion = [aDecoder decodeIntForKey:@"serverVersion"];
        self.serverSetupType = [aDecoder decodeIntForKey:@"serverSetupType"];
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
    newAppInfo.serverSetupType = self.serverSetupType;
    newAppInfo.displayItems = [self.displayItems lookin_map:^id(NSUInteger idx, LookinDisplayItem *oldItem) {
        return oldItem.copy;
    }];
    
    return newAppInfo;
}

@end
