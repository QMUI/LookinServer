#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

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
 In Lookin, a LookinAttributesGroup instance will be rendered as a property card.
 
 When isUserCustom is false: two LookinAttributesGroup instances will be regard as equal when they has the same LookinAttrGroupIdentifier.
 When isUserCustom is true: two LookinAttributesGroup instances will be regard as equal when they has the same title.
 当 isUserCustom 为 false 时：若两个 attrGroup 有相同的 LookinAttrGroupIdentifier，则 isEqual: 返回 YES
 */
@interface LookinAttributesGroup : NSObject <NSSecureCoding, NSCopying>

/// 只有在 identifier 为 custom 时，才存在该值
@property(nonatomic, copy) NSString *userCustomTitle;

@property(nonatomic, copy) LookinAttrGroupIdentifier identifier;

@property(nonatomic, copy) NSArray<LookinAttributesSection *> *attrSections;

/// 如果是 custom 则返回 userCustomTitle，如果不是 custom 则返回 identifier
- (NSString *)uniqueKey;

- (BOOL)isUserCustom;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
