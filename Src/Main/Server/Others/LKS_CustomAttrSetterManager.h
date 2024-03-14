#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrSetterManager.h
//  LookinServer
//
//  Created by likai.123 on 2023/11/4.
//

#import <UIKit/UIKit.h>

typedef void(^LKS_StringSetter)(NSString *);
typedef void(^LKS_NumberSetter)(NSNumber *);
typedef void(^LKS_BoolSetter)(BOOL);
typedef void(^LKS_ColorSetter)(UIColor *);
typedef void(^LKS_EnumSetter)(NSString *);
typedef void(^LKS_RectSetter)(CGRect);
typedef void(^LKS_SizeSetter)(CGSize);
typedef void(^LKS_PointSetter)(CGPoint);
typedef void(^LKS_InsetsSetter)(UIEdgeInsets);

@interface LKS_CustomAttrSetterManager : NSObject

+ (instancetype)sharedInstance;

- (void)removeAll;

- (void)saveStringSetter:(LKS_StringSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_StringSetter)getStringSetterWithID:(NSString *)uniqueID;

- (void)saveNumberSetter:(LKS_NumberSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_NumberSetter)getNumberSetterWithID:(NSString *)uniqueID;

- (void)saveBoolSetter:(LKS_BoolSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_BoolSetter)getBoolSetterWithID:(NSString *)uniqueID;

- (void)saveColorSetter:(LKS_ColorSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_ColorSetter)getColorSetterWithID:(NSString *)uniqueID;

- (void)saveEnumSetter:(LKS_EnumSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_EnumSetter)getEnumSetterWithID:(NSString *)uniqueID;

- (void)saveRectSetter:(LKS_RectSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_RectSetter)getRectSetterWithID:(NSString *)uniqueID;

- (void)saveSizeSetter:(LKS_SizeSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_SizeSetter)getSizeSetterWithID:(NSString *)uniqueID;

- (void)savePointSetter:(LKS_PointSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_PointSetter)getPointSetterWithID:(NSString *)uniqueID;

- (void)saveInsetsSetter:(LKS_InsetsSetter)setter uniqueID:(NSString *)uniqueID;
- (LKS_InsetsSetter)getInsetsSetterWithID:(NSString *)uniqueID;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
