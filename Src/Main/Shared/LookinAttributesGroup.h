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

@property(nonatomic, assign) BOOL isUserCustom;
/// Has value when isUserCustom is true
@property(nonatomic, copy) NSString *userCustomTitle;

@property(nonatomic, copy) LookinAttrGroupIdentifier identifier;

@property(nonatomic, copy) NSArray<LookinAttributesSection *> *attrSections;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
