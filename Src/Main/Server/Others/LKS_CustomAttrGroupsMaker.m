#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrGroupsMaker.m
//  LookinServer
//
//  Created by LikaiMacStudioWork on 2023/10/31.
//

#import "LKS_CustomAttrGroupsMaker.h"
#import "LKS_AttrGroupsMaker.h"
#import "LookinAttributesGroup.h"
#import "LookinAttributesSection.h"
#import "LookinAttribute.h"
#import "LookinDashboardBlueprint.h"
#import "LookinIvarTrace.h"
#import "UIColor+LookinServer.h"
#import "LookinServerDefines.h"

@implementation LKS_CustomAttrGroupsMaker

+ (NSArray<LookinAttributesGroup *> *)customAttrGroupsForLayer:(CALayer *)layer {
    if (!layer) {
        NSAssert(NO, @"");
        return nil;
    }
    NSMutableArray<NSString *> *selectors = [NSMutableArray array];
    [selectors addObject:@"lookin_customDebugInfos"];
    for (int i = 0; i < 5; i++) {
        [selectors addObject:[NSString stringWithFormat:@"lookin_customDebugInfos_%@", @(i)]];
    }
    
    NSMutableArray<LookinAttribute *> *allAttrs = [NSMutableArray array];
    for (NSString *name in selectors) {
        NSArray<LookinAttribute *> *layerAttrs = [self attrsForViewOrLayer:layer selectorName:name];
        [allAttrs addObjectsFromArray:layerAttrs];
        
        UIView *view = layer.lks_hostView;
        if (view) {
            NSArray<LookinAttribute *> *viewAttrs = [self attrsForViewOrLayer:view selectorName:name];
            [allAttrs addObjectsFromArray:viewAttrs];
        }
    }
    
    return nil;
}

+ (NSArray<LookinAttribute *> *)attrsForViewOrLayer:(id)viewOrLayer selectorName:(NSString *)selectorName {
    if (!viewOrLayer || !selectorName.length) {
        return nil;
    }
    if (![viewOrLayer isKindOfClass:[UIView class]] && ![viewOrLayer isKindOfClass:[CALayer class]]) {
        return nil;
    }
    SEL selector = NSSelectorFromString(selectorName);
    if (![viewOrLayer respondsToSelector:selector]) {
        return nil;
    }
    NSMethodSignature *signature = [viewOrLayer methodSignatureForSelector:selector];
    if (signature.numberOfArguments > 2) {
        NSAssert(NO, @"LookinServer - There should be no explicit parameters.");
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:viewOrLayer];
    [invocation setSelector:selector];
    [invocation invoke];
    
    // 小心这里的内存管理
    NSDictionary<NSString *, id> * __unsafe_unretained tempRawData;
    [invocation getReturnValue:&tempRawData];
    NSDictionary<NSString *, id> *rawData = tempRawData;
    
    NSArray<LookinAttribute *> *attrs = [self attrsFromRawData:rawData];
    if (!attrs || attrs.count == 0) {
        return nil;
    }
    return attrs;
}

+ (NSArray<LookinAttribute *> *)attrsFromRawData:(NSDictionary<NSString *, id> *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSArray *rawProperties = data[@"properties"];
    if (!rawProperties || [rawProperties isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray<LookinAttribute *> *attrs = [NSMutableArray array];
    for (NSDictionary<NSString *, id> *dict in rawProperties) {
        LookinAttribute *attr = [self attrFromRawDict:dict];
        if (!attr) {
            [attrs addObject:attr];
        }
    }
    return attrs;
}

+ (LookinAttribute *)attrFromRawDict:(NSDictionary *)dict {
    LookinAttribute *attr = [LookinAttribute new];
    attr.identifier = LookinAttr_UserCustom;
    
    NSString *type = dict[@"valueType"];
    NSString *section = dict[@"section"] ? : @"Custom";
    id value = dict[@"value"];
    
    if (!type || ![type isKindOfClass:[NSString class]]) {
        NSLog(@"LookinServer - Wrong valueType");
        return nil;
    }
    if (!section || ![section isKindOfClass:[NSString class]]) {
        NSLog(@"LookinServer - Wrong section");
        return nil;
    }
    if (!value) {
        NSLog(@"LookinServer - No value");
        return nil;
    }
    
    NSString *fixedType = type.lowercaseString;
    if ([fixedType isEqualToString:@"string"]) {
        if (![value isKindOfClass:[NSString class]]) {
            NSLog(@"LookinServer - Wrong value type.");
            return nil;
        }
        attr.attrType = LookinAttrTypeNSString;
        attr.value = value;
        return attr;
    }
    
    if ([fixedType isEqualToString:@"number"]) {
        if (![value isKindOfClass:[NSNumber class]]) {
            NSLog(@"LookinServer - Wrong value type.");
            return nil;
        }
        attr.attrType = LookinAttrTypeDouble;
        attr.value = value;
        return attr;
    }
        
    if ([fixedType isEqualToString:@"bool"]) {
        if (![value isKindOfClass:[NSNumber class]]) {
            NSLog(@"LookinServer - Wrong value type.");
            return nil;
        }
        attr.attrType = LookinAttrTypeBOOL;
        attr.value = value;
        return attr;
    }
    
    if ([fixedType isEqualToString:@"color"]) {
        if (![value isKindOfClass:[UIColor class]]) {
            NSLog(@"LookinServer - Wrong value type.");
            return nil;
        }
        attr.attrType = LookinAttrTypeUIColor;
        attr.value = [(UIColor *)value lks_rgbaComponents];
        return attr;
        
    }
    
    if ([fixedType isEqualToString:@"enum"]) {
        if (![value isKindOfClass:[NSString class]]) {
            NSLog(@"LookinServer - Wrong value type.");
            return nil;
        }
        attr.attrType = LookinAttrTypeEnumString;
        attr.value = value;
        
        NSArray<NSString *> *allEnumCases = dict[@"allEnumCases"];
        if ([allEnumCases isKindOfClass:[NSArray class]]) {
            attr.extraValue = allEnumCases;
        }
        return attr;
        
    }
    
    NSLog(@"LookinServer - Unsupported value type.");
    return nil;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
