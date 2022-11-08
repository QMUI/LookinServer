#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinConnectionAttachment.h
//  Lookin
//
//  Created by Li Kai on 2019/2/15.
//  https://lookin.work
//



#import <Foundation/Foundation.h>
#import "LookinCodingValueType.h"

@interface LookinConnectionAttachment : NSObject <NSSecureCoding>

@property(nonatomic, assign) LookinCodingValueType dataType;

@property(nonatomic, strong) id data;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
