#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

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

/// 只有 Custom Attr 才有该属性
@property(nonatomic, copy) NSString *displayTitle;

/// 标识 value 的具体类型（如 double / NSString /...）
@property(nonatomic, assign) LookinAttrType attrType;

/// 具体的值，需配合 attrType 属性来解析它
@property(nonatomic, strong) id value;

/// 额外信息，大部分情况下它是 nil
/// 当 attyType 为 LookinAttrTypeEnumString 时，extraValue 是一个 [String] 且保存了 allEnumCases
@property(nonatomic, strong) id extraValue;

#pragma mark - 以下属性不会参与 encode/decode

/// 标识该 LookinAttribute 对象隶属于哪一个 LookinDisplayItem
@property(nonatomic, weak) LookinDisplayItem *targetDisplayItem;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
