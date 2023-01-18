#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LKSConfigManager.m
//  LookinServer
//
//  Created by likai.123 on 2023/1/10.
//

#import "LKSConfigManager.h"
#import "NSArray+Lookin.h"
#import "CALayer+LookinServer.h"

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

+ (BOOL)shouldCaptureScreenshotOfLayer:(CALayer *)layer {
    if (!layer) {
        return YES;
    }
    if (![self shouldCaptureImageOfLayer:layer]) {
        return NO;
    }
    UIView *view = layer.lks_hostView;
    if (!view) {
        return YES;
    }
    if (![self shouldCaptureImageOfView:view]) {
        return NO;
    }
    return YES;
}

+ (BOOL)shouldCaptureImageOfLayer:(CALayer *)layer {
    if (!layer) {
        return YES;
    }
    SEL selector = NSSelectorFromString(@"lookin_shouldCaptureImageOfLayer:");
    if ([NSObject respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSObject methodSignatureForSelector:selector]];
        [invocation setTarget:[NSObject class]];
        [invocation setSelector:selector];
        [invocation setArgument:&layer atIndex:2];
        [invocation invoke];
        BOOL resultValue = YES;
        [invocation getReturnValue:&resultValue];
        if (!resultValue) {
            return NO;
        }
    }

    SEL selector2 = NSSelectorFromString(@"lookin_shouldCaptureImage");
    if ([layer respondsToSelector:selector2]) {
        NSInvocation *invocation2 = [NSInvocation invocationWithMethodSignature:[layer methodSignatureForSelector:selector2]];
        [invocation2 setTarget:layer];
        [invocation2 setSelector:selector2];
        [invocation2 invoke];
        BOOL resultValue2 = YES;
        [invocation2 getReturnValue:&resultValue2];
        if (!resultValue2) {
            return NO;
        }
    }

    return YES;
}

+ (BOOL)shouldCaptureImageOfView:(UIView *)view {
    if (!view) {
        return YES;
    }
    
    SEL selector = NSSelectorFromString(@"lookin_shouldCaptureImageOfView:");
    if ([NSObject respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[NSObject methodSignatureForSelector:selector]];
        [invocation setTarget:[NSObject class]];
        [invocation setSelector:selector];
        [invocation setArgument:&view atIndex:2];
        [invocation invoke];
        BOOL resultValue = YES;
        [invocation getReturnValue:&resultValue];
        if (!resultValue) {
            return NO;
        }
    }
    
    SEL selector2 = NSSelectorFromString(@"lookin_shouldCaptureImage");
    if ([view respondsToSelector:selector2]) {
        NSInvocation *invocation2 = [NSInvocation invocationWithMethodSignature:[view methodSignatureForSelector:selector2]];
        [invocation2 setTarget:view];
        [invocation2 setSelector:selector2];
        [invocation2 invoke];
        BOOL resultValue2 = YES;
        [invocation2 getReturnValue:&resultValue2];
        if (!resultValue2) {
            return NO;
        }
    }

    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
