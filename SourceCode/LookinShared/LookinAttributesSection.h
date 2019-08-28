//
//  LookinAttributesSection.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LookinAttributeIdentifiers.h"

@class LookinAttribute;

typedef NS_ENUM (NSInteger, LookinAttributesSectionStyle) {
    LookinAttributesSectionStyleDefault,    // 每个 attr 独占一行
    LookinAttributesSectionStyle0,  // frame 等卡片使用，前 4 个 attr 每行两个，之后每个 attr 在同一排，每个宽度为 1/4
    LookinAttributesSectionStyle1,  // 第一个 attr 在第一排靠左，第二个 attr 在第一排靠右，之后的 attr 每个独占一行
    LookinAttributesSectionStyle2   // 第一排独占一行，剩下的在同一行且均分宽度
};

@interface LookinAttributesSection : NSObject <NSSecureCoding>

@property(nonatomic, assign) LookinAttrSectionIdentifier identifier;

@property(nonatomic, copy) NSArray<LookinAttribute *> *attributes;

#pragma mark - No Coding

+ (NSString *)titleWithIdentifier:(LookinAttrSectionIdentifier)identifier;
+ (NSString *)introductionWithIdentifier:(LookinAttrSectionIdentifier)identifier;

@property(nonatomic, assign) LookinAttributesSectionStyle style;


@end
