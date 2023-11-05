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
/// 对于 String、Color 等 attyType，该属性可能为 nil
@property(nonatomic, strong) id value;

/// 额外信息，大部分情况下它是 nil
/// 当 attyType 为 LookinAttrTypeEnumString 时，extraValue 是一个 [String] 且保存了 allEnumCases
@property(nonatomic, strong) id extraValue;

/// 仅 Custom Attr 可能有该属性
/// 对于有 retainedSetter 的 Custom Attr，它的 setter 会以 customSetterID 作为 key 被保存到 LKS_CustomAttrSetterManager 里，后续可以通过这个 uniqueID 重新把 setter 从 LKS_CustomAttrSetterManager 里取出来并调用
@property(nonatomic, copy) NSString *customSetterID;

#pragma mark - 以下属性不会参与 encode/decode

/// 标识该 LookinAttribute 对象隶属于哪一个 LookinDisplayItem
@property(nonatomic, weak) LookinDisplayItem *targetDisplayItem;

- (BOOL)isUserCustom;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
