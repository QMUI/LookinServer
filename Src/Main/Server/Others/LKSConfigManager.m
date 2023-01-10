//
//  LKSConfigManager.m
//  LookinServer
//
//  Created by likai.123 on 2023/1/10.
//

#import "LKSConfigManager.h"
#import "NSArray+Lookin.h"

@implementation LKSConfigManager

+ (NSArray<NSString *> *)collapsedClassList {
    NSArray<NSString *> *result = [self queryCollapsedClassListWithClass:[NSObject class] selector:@"lookin_collapsedClassList"];
    if (result) {
        return result;
    }
    
    // Legacy logic. Deprecated.
    Class configClass = NSClassFromString(@"LookinConfig");
    if (!configClass) {
        return nil;
    }
    NSArray<NSString *> *legacyCodeResult = [self queryCollapsedClassListWithClass:configClass selector:@"collapsedClasses"];
    return legacyCodeResult;
}

+ (NSArray<NSString *> *)queryCollapsedClassListWithClass:(Class)class selector:(NSString *)selectorName {
    SEL selector = NSSelectorFromString(selectorName);
    if (![class respondsToSelector:selector]) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[class methodSignatureForSelector:selector]];
    [invocation setTarget:class];
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
    NSDictionary<NSString *, UIColor *> *result = [self queryColorAliasWithClass:[NSObject class] selector:@"lookin_colorAlias"];
    if (result) {
        return result;
    }
    
    // Legacy logic. Deprecated.
    Class configClass = NSClassFromString(@"LookinConfig");
    if (!configClass) {
        return nil;
    }
    NSDictionary<NSString *, UIColor *> *legacyCodeResult = [self queryColorAliasWithClass:configClass selector:@"colors"];
    return legacyCodeResult;
}

+ (NSDictionary<NSString *, UIColor *> *)queryColorAliasWithClass:(Class)class selector:(NSString *)selectorName {
    SEL selector = NSSelectorFromString(selectorName);
    if (![class respondsToSelector:selector]) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[class methodSignatureForSelector:selector]];
    [invocation setTarget:class];
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

@end
