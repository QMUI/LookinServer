//
//  LookinAttributeModification.h
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LookinAttrType.h"

@interface LookinAttributeModification : NSObject <NSSecureCoding>

@property(nonatomic, assign) unsigned long targetOid;

@property(nonatomic, assign) SEL setterSelector;
@property(nonatomic, assign) SEL getterSelector;

@property(nonatomic, assign) LookinAttrType attrType;
@property(nonatomic, strong) id value;

@end
