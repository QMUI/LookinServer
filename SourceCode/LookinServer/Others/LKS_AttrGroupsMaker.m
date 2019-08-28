//
//  LKS_AttrGroupsMaker.m
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LKS_AttrGroupsMaker.h"
#import "LookinAttributesGroup.h"
#import "LookinAttributesSection.h"
#import "LookinAttribute.h"
#import "LookinDashboardBlueprint.h"
#import "LookinIvarTrace.h"

@implementation LKS_AttrGroupsMaker

+ (NSArray<LookinAttributesGroup *> *)attrGroupsForLayer:(CALayer *)layer {
    if (!layer) {
        NSAssert(NO, @"");
        return nil;
    }
    NSArray<LookinAttributesGroup *> *groups = [[LookinDashboardBlueprint groupIDs] lookin_map:^id(NSUInteger idx, NSNumber *groupID_Num) {
        NSInteger groupID = [groupID_Num integerValue];
        
        LookinAttributesGroup *group = [LookinAttributesGroup new];
        group.identifier = groupID;

        NSArray<NSNumber *> *secIDs = [LookinDashboardBlueprint sectionIDsForGroupID:groupID];
        group.attrSections = [secIDs lookin_map:^id(NSUInteger idx, NSNumber *secID_Num) {
            LookinAttrSectionIdentifier secID = [secID_Num integerValue];
            
            LookinAttributesSection *sec = [LookinAttributesSection new];
            sec.identifier = secID;
            
            NSArray<NSNumber *> *attrIDs = [LookinDashboardBlueprint attrIDsForSectionID:secID];
            sec.attributes = [attrIDs lookin_map:^id(NSUInteger idx, NSNumber *attrID_Num) {
                LookinAttrIdentifier attrID = [attrID_Num integerValue];
                if (attrID == LookinAttr_ViewLayer_SafeArea_Area
                    || attrID == LookinAttr_UIScrollView_AdjustedInset_Inset ||
                    attrID == LookinAttr_UIScrollView_Behavior_Behavior) {
                    if (@available(iOS 11.0, *)) {
                    } else {
                        return nil;
                    }
                }
                
                LookinAttributeHostType hostType = [LookinAttribute hostTypeWithIdentifier:attrID];
                id targetObj = layer;
                if (hostType == LookinAttributeHostTypeView) {
                    targetObj = layer.lks_hostView;
                }
                if (targetObj) {
                    Class targetClass = NSClassFromString([LookinAttribute hostClassNameWithIdentifier:attrID]);
                    if (![targetObj isKindOfClass:targetClass]) {
                        return nil;
                    }
                    
                    LookinAttribute *attr = [self _attributeWithIdentifer:attrID targetObject:targetObj];
                    return attr;
                } else {
                    return nil;
                }
            }];
            
            if (sec.attributes.count) {
                return sec;
            } else {
                return nil;
            }
        }];
        
        if (group.attrSections.count) {
            return group;
        } else {
            return nil;
        }
    }];
    
    return groups;
}

+ (LookinAttribute *)_attributeWithIdentifer:(LookinAttrIdentifier)identifier targetObject:(id)target {
    if (!target) {
        NSAssert(NO, @"");
        return nil;
    }
    
    LookinAttribute *attribute = [LookinAttribute new];
    attribute.identifier = identifier;
    
    if (identifier == LookinAttr_UITableView_RowsNumber_Number) {
        attribute.attrType = LookinAttrTypeCustom;
        attribute.value = [self _numberOfRowsInTableView:target];
        return attribute.value ? attribute : nil;
    }
    if (identifier == LookinAttr_Class_Class_Class) {
        attribute.attrType = LookinAttrTypeCustom;
        attribute.value = [self _relatedClassChainListWithLayer:target];
        return attribute.value ? attribute : nil;
    }
    if (identifier == LookinAttr_Relation_Relation_Relation) {
        attribute.attrType = LookinAttrTypeCustom;
        attribute.value = [self _relationWithLayer:target];
        return attribute.value ? attribute : nil;
    }
    
    SEL getter = attribute.getter;
    if (!getter || ![target respondsToSelector:getter]) {
        NSAssert(NO, @"");
        return nil;
    }
    NSMethodSignature *signature = [target methodSignatureForSelector:getter];
    if (signature.numberOfArguments > 2) {
        NSAssert(NO, @"getter 不可以有参数");
        return nil;
    }
    if (strcmp([signature methodReturnType], @encode(void)) == 0) {
        NSAssert(NO, @"getter 返回值不能为 void");
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = getter;
    [invocation invoke];
    
    const char *returnType = [signature methodReturnType];
    
    if (strcmp(returnType, @encode(char)) == 0) {
        char targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeChar;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(int)) == 0) {
        int targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.value = @(targetValue);
        if ([LookinAttribute enumListNameWithIdentifier:identifier]) {
            attribute.attrType = LookinAttrTypeEnumInt;
        } else {
            attribute.attrType = LookinAttrTypeInt;
        }
        
    } else if (strcmp(returnType, @encode(short)) == 0) {
        short targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeShort;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(long)) == 0) {
        long targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.value = @(targetValue);
        if ([LookinAttribute enumListNameWithIdentifier:identifier]) {
            attribute.attrType = LookinAttrTypeEnumLong;
        } else {
            attribute.attrType = LookinAttrTypeLong;
        }
        
    } else if (strcmp(returnType, @encode(long long)) == 0) {
        long long targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeLongLong;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        unsigned char targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeUnsignedChar;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        unsigned int targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeUnsignedInt;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        unsigned short targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeUnsignedShort;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        unsigned long targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeUnsignedLong;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        unsigned long long targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeUnsignedLongLong;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(float)) == 0) {
        float targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeFloat;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(double)) == 0) {
        double targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeDouble;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(BOOL)) == 0) {
        BOOL targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeBOOL;
        attribute.value = @(targetValue);
        
    } else if (strcmp(returnType, @encode(SEL)) == 0) {
        SEL targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeSel;
        attribute.value = NSStringFromSelector(targetValue);
        
    } else if (strcmp(returnType, @encode(Class)) == 0) {
        Class targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeClass;
        attribute.value = NSStringFromClass(targetValue);
        
    } else if (strcmp(returnType, @encode(CGPoint)) == 0) {
        CGPoint targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeCGPoint;
        attribute.value = [NSValue valueWithCGPoint:targetValue];
        
    } else if (strcmp(returnType, @encode(CGVector)) == 0) {
        CGVector targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeCGVector;
        attribute.value = [NSValue valueWithCGVector:targetValue];
        
    } else if (strcmp(returnType, @encode(CGSize)) == 0) {
        CGSize targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeCGSize;
        attribute.value = [NSValue valueWithCGSize:targetValue];
        
    } else if (strcmp(returnType, @encode(CGRect)) == 0) {
        CGRect targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeCGRect;
        attribute.value = [NSValue valueWithCGRect:targetValue];
        
    } else if (strcmp(returnType, @encode(CGAffineTransform)) == 0) {
        CGAffineTransform targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeCGAffineTransform;
        attribute.value = [NSValue valueWithCGAffineTransform:targetValue];
        
    } else if (strcmp(returnType, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeUIEdgeInsets;
        attribute.value = [NSValue valueWithUIEdgeInsets:targetValue];
        
    } else if (strcmp(returnType, @encode(UIOffset)) == 0) {
        UIOffset targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeUIOffset;
        attribute.value = [NSValue valueWithUIOffset:targetValue];
        
    } else if (strcmp(returnType, @encode(NSString)) == 0) {
        __unsafe_unretained NSString *targetValue;
        [invocation getReturnValue:&targetValue];
        attribute.attrType = LookinAttrTypeNSString;
        attribute.value = targetValue;
        
    } else {
        NSString *argType_string = [[NSString alloc] lookin_safeInitWithUTF8String:returnType];
        if ([argType_string hasPrefix:@"@"]) {
            __unsafe_unretained id returnObjValue;
            [invocation getReturnValue:&returnObjValue];
            
            attribute.attrType = [LookinAttribute objectAttrTypeWithIdentifer:identifier];
            if (attribute.attrType == LookinAttrTypeUIColor) {
                attribute.value = [returnObjValue lks_rgbaComponents];
            } else {
                return nil;
            }
            
        } else {
            NSAssert(NO, @"不支持解析该类型的返回值");
            return nil;
        }
    }
    
    return attribute;
}

+ (NSArray<NSNumber *> *)_numberOfRowsInTableView:(UITableView *)tableView {
    if (!tableView || ![tableView isKindOfClass:[UITableView class]]) {
        return nil;
    }
    NSUInteger sectionsCount = MIN(tableView.numberOfSections, 10);
    NSArray<NSNumber *> *rowsCount = [NSArray arrayWithCount:sectionsCount block:^id(NSUInteger idx) {
        return @([tableView numberOfRowsInSection:idx]);
    }];
    if (rowsCount.count == 0) {
        return nil;
    }
    return rowsCount;
}

/// 获取和该对象有关的对象的 Class 层级树
+ (NSArray<NSArray<NSString *> *> *)_relatedClassChainListWithLayer:(CALayer *)layer {
    if (![layer isKindOfClass:[CALayer class]]) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    if (layer.lks_hostView) {
        [array addObject:layer.lks_hostView.lks_classChainList];
        
        if (layer.lks_hostView.lks_hostViewController) {
            [array addObject:layer.lks_hostView.lks_hostViewController.lks_classChainList];
        }
    } else {
        [array addObject:layer.lks_classChainList];
    }
    return array.copy;
}

+ (NSArray<NSString *> *)_relationWithLayer:(CALayer *)layer {
    if (![layer isKindOfClass:[CALayer class]]) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray<LookinIvarTrace *> *ivarTraces = [NSMutableArray array];
    if (layer.lks_hostView) {
        if (layer.lks_hostView.lks_hostViewController) {
            [array addObject:[NSString stringWithFormat:@"(%@ *).view", NSStringFromClass(layer.lks_hostView.lks_hostViewController.class)]];
            
            [ivarTraces addObjectsFromArray:layer.lks_hostView.lks_hostViewController.lks_ivarTraces];
        }
        [ivarTraces addObjectsFromArray:layer.lks_hostView.lks_ivarTraces];
    } else {
        [ivarTraces addObjectsFromArray:layer.lks_ivarTraces];
    }
    if (ivarTraces.count) {
        [array addObjectsFromArray:[ivarTraces lookin_map:^id(NSUInteger idx, LookinIvarTrace *value) {
            return [NSString stringWithFormat:@"(%@ *) -> %@", value.hostClassName, value.ivarName];
        }]];
    }
    return array.count ? array.copy : nil;
}

@end
