#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAttributesSection.h
//  Lookin
//
//  Created by Li Kai on 2019/3/2.
//  https://lookin.work
//



#import <Foundation/Foundation.h>
#import "LookinAttrIdentifiers.h"

@class LookinAttribute;

typedef NS_ENUM (NSInteger, LookinAttributesSectionStyle) {
    LookinAttributesSectionStyleDefault,    // 每个 attr 独占一行
    LookinAttributesSectionStyle0,  // frame 等卡片使用，前 4 个 attr 每行两个，之后每个 attr 在同一排，每个宽度为 1/4
    LookinAttributesSectionStyle1,  // 第一个 attr 在第一排靠左，第二个 attr 在第一排靠右，之后的 attr 每个独占一行
    LookinAttributesSectionStyle2   // 第一排独占一行，剩下的在同一行且均分宽度
};

@interface LookinAttributesSection : NSObject <NSSecureCoding, NSCopying>

@property(nonatomic, copy) LookinAttrSectionIdentifier identifier;

@property(nonatomic, copy) NSArray<LookinAttribute *> *attributes;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
