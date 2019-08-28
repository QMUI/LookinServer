//
//  LookinAttributesGroup.h
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LookinAttributeIdentifiers.h"

@class LookinAttributesSection;

/**
 在 Lookin 中，一个 LookinAttributesGroup 会被对应渲染为一张卡片
 
 如果两个 attrGroup 有相同的 LookinAttrGroupIdentifier，则 isEqual: 返回 YES
 */
@interface LookinAttributesGroup : NSObject <NSSecureCoding>

@property(nonatomic, assign) LookinAttrGroupIdentifier identifier;

@property(nonatomic, copy) NSArray<LookinAttributesSection *> *attrSections;

+ (NSString *)titleWithIdentifier:(LookinAttrGroupIdentifier)identifier;

@end
