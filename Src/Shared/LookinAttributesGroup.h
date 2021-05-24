//
//  LookinAttributesGroup.h
//  Lookin
//
//  Created by Li Kai on 2018/11/19.
//  https://lookin.work
//



#import <Foundation/Foundation.h>
#import "LookinAttrIdentifiers.h"

@class LookinAttributesSection;

/**
 在 Lookin 中，一个 LookinAttributesGroup 会被对应渲染为一张卡片
 
 如果两个 attrGroup 有相同的 LookinAttrGroupIdentifier，则 isEqual: 返回 YES
 */
@interface LookinAttributesGroup : NSObject <NSSecureCoding, NSCopying>

@property(nonatomic, copy) LookinAttrGroupIdentifier identifier;

@property(nonatomic, copy) NSArray<LookinAttributesSection *> *attrSections;

@end
