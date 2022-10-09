//
//  LookinAttrIdentifiers.h
//  Lookin
//
//  Created by Li Kai on 2018/12/1.
//  https://lookin.work
//



typedef NS_ENUM(NSInteger, LookinAttrType) {
    LookinAttrTypeNone,
    LookinAttrTypeVoid,
    LookinAttrTypeChar,
    LookinAttrTypeInt,
    LookinAttrTypeShort,
    LookinAttrTypeLong,
    LookinAttrTypeLongLong,
    LookinAttrTypeUnsignedChar,
    LookinAttrTypeUnsignedInt,
    LookinAttrTypeUnsignedShort,
    LookinAttrTypeUnsignedLong,
    LookinAttrTypeUnsignedLongLong,
    LookinAttrTypeFloat,
    LookinAttrTypeDouble,
    LookinAttrTypeBOOL,
    LookinAttrTypeSel,
    LookinAttrTypeClass,
    LookinAttrTypeCGPoint,
    LookinAttrTypeCGVector,
    LookinAttrTypeCGSize,
    LookinAttrTypeCGRect,
    LookinAttrTypeCGAffineTransform,
    LookinAttrTypeUIEdgeInsets,
    LookinAttrTypeUIOffset,
    LookinAttrTypeNSString,
    LookinAttrTypeEnumInt,
    LookinAttrTypeEnumLong,
    /// value 实际为 RGBA 数组，即 @[NSNumber, NSNumber, NSNumber, NSNumber]，NSNumber 范围是 0 ~ 1
    LookinAttrTypeUIColor,
    /// 业务需要根据具体的 AttrIdentifier 来解析
    LookinAttrTypeCustomObj,
};
