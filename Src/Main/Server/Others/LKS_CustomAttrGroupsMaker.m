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

@interface LKS_CustomAttrGroupsMaker ()

/// key 是 section title
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<LookinAttribute *> *> *sectionAndAttrs;

@property(nonatomic, weak) CALayer *layer;

@end

@implementation LKS_CustomAttrGroupsMaker

- (instancetype)initWithLayer:(CALayer *)layer {
    if (self = [super init]) {
        self.sectionAndAttrs = [NSMutableDictionary dictionary];
        self.layer = layer;
    }
    return self;
}

- (NSArray<LookinAttributesGroup *> *)make {
    if (!self.layer) {
        NSAssert(NO, @"");
        return nil;
    }
    NSMutableArray<NSString *> *selectors = [NSMutableArray array];
    [selectors addObject:@"lookin_customDebugInfos"];
    for (int i = 0; i < 5; i++) {
        [selectors addObject:[NSString stringWithFormat:@"lookin_customDebugInfos_%@", @(i)]];
    }
    
    for (NSString *name in selectors) {
        [self makeAttrsForViewOrLayer:self.layer selectorName:name];
        
        UIView *view = self.layer.lks_hostView;
        if (view) {
            [self makeAttrsForViewOrLayer:view selectorName:name];
        }
    }
    
    if ([self.sectionAndAttrs count] == 0) {
        return nil;
    }
    NSMutableArray<LookinAttributesGroup *> *groups = [NSMutableArray array];
    [self.sectionAndAttrs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull groupTitle, NSMutableArray<LookinAttribute *> * _Nonnull attrs, BOOL * _Nonnull stop) {
        LookinAttributesGroup *group = [LookinAttributesGroup new];
        group.userCustomTitle = groupTitle;
        group.identifier = LookinAttrGroup_UserCustom;
        
        NSMutableArray<LookinAttributesSection *> *sections = [NSMutableArray array];
        [attrs enumerateObjectsUsingBlock:^(LookinAttribute * _Nonnull attr, NSUInteger idx, BOOL * _Nonnull stop) {
            LookinAttributesSection *sec = [LookinAttributesSection new];
            sec.identifier = LookinAttrSec_UserCustom;
            sec.attributes = @[attr];
            [sections addObject:sec];
        }];
        
        group.attrSections = sections;
    }];
    [groups sortedArrayUsingComparator:^NSComparisonResult(LookinAttributesGroup *obj1, LookinAttributesGroup *obj2) {
        return [obj1.userCustomTitle compare:obj2.userCustomTitle];
    }];
    return [groups copy];
}

- (void)makeAttrsForViewOrLayer:(id)viewOrLayer selectorName:(NSString *)selectorName {
    if (!viewOrLayer || !selectorName.length) {
        return;
    }
    if (![viewOrLayer isKindOfClass:[UIView class]] && ![viewOrLayer isKindOfClass:[CALayer class]]) {
        return;
    }
    SEL selector = NSSelectorFromString(selectorName);
    if (![viewOrLayer respondsToSelector:selector]) {
        return;
    }
    NSMethodSignature *signature = [viewOrLayer methodSignatureForSelector:selector];
    if (signature.numberOfArguments > 2) {
        NSAssert(NO, @"LookinServer - There should be no explicit parameters.");
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:viewOrLayer];
    [invocation setSelector:selector];
    [invocation invoke];
    
    // 小心这里的内存管理
    NSDictionary<NSString *, id> * __unsafe_unretained tempRawData;
    [invocation getReturnValue:&tempRawData];
    NSDictionary<NSString *, id> *rawData = tempRawData;
    
    [self makeAttrsFromRawData:rawData];
}

- (void)makeAttrsFromRawData:(NSDictionary<NSString *, id> *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *rawProperties = data[@"properties"];
    if (!rawProperties || [rawProperties isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSDictionary<NSString *, id> *dict in rawProperties) {
        NSString *section;
        LookinAttribute *attr = [self attrFromRawDict:dict section:&section];
        if (!attr) {
            continue;
        }
        if (!self.sectionAndAttrs[section]) {
            self.sectionAndAttrs[section] = [NSMutableArray array];
        }
        [self.sectionAndAttrs[section] addObject:attr];
    }
}

- (LookinAttribute *)attrFromRawDict:(NSDictionary *)dict section:(inout NSString **)inoutSectionTitle {
    LookinAttribute *attr = [LookinAttribute new];
    attr.identifier = LookinAttr_UserCustom;
    
    NSString *title = dict[@"title"];
    NSString *type = dict[@"valueType"];
    NSString *section = dict[@"section"];
    id value = dict[@"value"];

    if (!title || ![title isKindOfClass:[NSString class]]) {
        NSLog(@"LookinServer - Wrong title");
        return nil;
    }
    if (!type || ![type isKindOfClass:[NSString class]]) {
        NSLog(@"LookinServer - Wrong valueType");
        return nil;
    }
    if (!value) {
        NSLog(@"LookinServer - No value");
        return nil;
    }
    if (!section || ![section isKindOfClass:[NSString class]] || section.length == 0) {
        *inoutSectionTitle = @"Custom";
    } else {
        *inoutSectionTitle = section;
    }
    
    attr.displayTitle = title;
    
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
