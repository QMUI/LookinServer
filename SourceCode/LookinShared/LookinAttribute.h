//
//  LookinAttribute.h
//  
//
//  
//

#import "LookinDefines.h"
#import "LookinAttributeIdentifiers.h"
#import "LookinCodingValueType.h"
#import "LookinAttrType.h"

@class LookinDisplayItem;

typedef NS_ENUM(NSInteger, LookinAttributeHostType) {
    LookinAttributeHostTypeNone,
    LookinAttributeHostTypeView,
    LookinAttributeHostTypeLayer
};

@interface LookinAttribute : NSObject <NSSecureCoding>

@property(nonatomic, assign) LookinAttrIdentifier identifier;

/// 具体的值，需配合 attrType 属性来解析它
@property(nonatomic, strong) id value;

/// 标识 value 的具体类型（如 double / NSString /...）
@property(nonatomic, assign) LookinAttrType attrType;

#pragma mark - 以下属性不会参与 encode/decode

/// 当某个 LookinAttribute 确定是 NSObject 类型时，该方法返回它具体是什么对象，比如 NSString, UIColor 等
+ (LookinAttrType)objectAttrTypeWithIdentifer:(LookinAttrIdentifier)identifier;

/// 返回某个 LookinAttribute 代表的属性是哪一个类拥有的，比如 LookinAttrSec_UILabel_TextColor 是 UILabel 才有的
+ (NSString *)hostClassNameWithIdentifier:(LookinAttrIdentifier)identifier;

/// 标识该 LookinAttribute 对象隶属于哪一个 LookinDisplayItem
@property(nonatomic, weak) LookinDisplayItem *targetDisplayItem;

/// 返回某个 LookinAttribute 代表的属性是属于 UIView 还是 CALayer，比如 LookinAttrSec_UILabel_TextColor 属于 UIView，而 LookinAttrSec_ViewLayer_BgColor 属于 CALayer
+ (LookinAttributeHostType)hostTypeWithIdentifier:(LookinAttrIdentifier)identifier;

/// 如果某个 attribute 是 enum，则这里会返回相应的 enum 的名称（如 @"NSTextAlignment"），进而可通过这个名称查询可用的枚举值列表
+ (NSString *)enumListNameWithIdentifier:(LookinAttrIdentifier)identifier;

/// 如果存在 customTitle 则显示 customTitle，否则显示默认 title
@property(nonatomic, copy, readonly) NSString *title;

/// 如果可在 Lookin 中被修改，则该属性为相应的 setter 方法，否则该属性为 nil
@property(nonatomic, assign, readonly) SEL setter;
@property(nonatomic, assign, readonly) SEL getter;

/// 如果返回 YES，则说明用户在 Lookin 里修改了该 Attribute 的值后，应该重新拉取和更新相关图层的位置、截图等信息
- (BOOL)needPatchAfterModification;

@end
