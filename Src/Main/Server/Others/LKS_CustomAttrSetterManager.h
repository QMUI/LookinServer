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

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
