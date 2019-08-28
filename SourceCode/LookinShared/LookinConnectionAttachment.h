//
//  LookinConnectionAttachment.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LookinCodingValueType.h"

@interface LookinConnectionAttachment : NSObject <NSSecureCoding>

@property(nonatomic, assign) LookinCodingValueType dataType;

@property(nonatomic, strong) id data;

@end
