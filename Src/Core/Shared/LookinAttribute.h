//
//  LookinAttribute.h
//  qmuidemo
//
//  Created by Li Kai on 2018/11/17.
//  Copyright © 2018 QMUI Team. All rights reserved.
//



#import "LookinAttrIdentifiers.h"
#import "LookinCodingValueType.h"
#import "LookinAttrType.h"

@class LookinDisplayItem;

@interface LookinAttribute : NSObject <NSSecureCoding, NSCopying>

@property(nonatomic, copy) LookinAttrIdentifier identifier;

/// 具体的值，需配合 attrType 属性来解析它
@property(nonatomic, strong) id value;

/// 标识 value 的具体类型（如 double / NSString /...）
@property(nonatomic, assign) LookinAttrType attrType;

#pragma mark - 以下属性不会参与 encode/decode

/// 标识该 LookinAttribute 对象隶属于哪一个 LookinDisplayItem
@property(nonatomic, weak) LookinDisplayItem *targetDisplayItem;

@end
