#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAttributeModification.h
//  Lookin
//
//  Created by Li Kai on 2018/11/20.
//  https://lookin.work
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

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
