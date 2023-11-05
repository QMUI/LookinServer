#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrModificationHandler.m
//  LookinServer
//
//  Created by likaimacbookhome on 2023/11/4.
//

#import "LKS_CustomAttrModificationHandler.h"
#import "LKS_CustomAttrSetterManager.h"
#import "UIColor+LookinServer.h"

@implementation LKS_CustomAttrModificationHandler

+ (BOOL)handleModification:(LookinCustomAttrModification *)modification {
    if (!modification || modification.customSetterID.length == 0) {
        return NO;
    }
    switch (modification.attrType) {
        case LookinAttrTypeNSString: {
            NSString *newValue = modification.value;
            if (newValue != nil && ![newValue isKindOfClass:[NSString class]]) {
                // nil 是合法的
                return NO;
            }
            LKS_StringSetter setter = [[LKS_CustomAttrSetterManager sharedInstance] getStringSetterWithID:modification.customSetterID];
            if (!setter) {
                return NO;
            }
            setter(newValue);
            return YES;
        }
            
        case LookinAttrTypeDouble: {
            NSNumber *newValue = modification.value;
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return NO;
            }
            LKS_NumberSetter setter = [[LKS_CustomAttrSetterManager sharedInstance] getNumberSetterWithID:modification.customSetterID];
            if (!setter) {
                return NO;
            }
            setter(newValue);
            return YES;
        }
            
        case LookinAttrTypeBOOL: {
            NSNumber *newValue = modification.value;
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return NO;
            }
            LKS_BoolSetter setter = [[LKS_CustomAttrSetterManager sharedInstance] getBoolSetterWithID:modification.customSetterID];
            if (!setter) {
                return NO;
            }
            setter(newValue.boolValue);
            return YES;
        }
        
        case LookinAttrTypeUIColor: {
            LKS_ColorSetter setter = [[LKS_CustomAttrSetterManager sharedInstance] getColorSetterWithID:modification.customSetterID];
            if (!setter) {
                return NO;
            }
            
            NSArray<NSNumber *> *newValue = modification.value;
            if (newValue == nil) {
                // nil 是合法的
                setter(nil);
                return YES;
            }
            if (![newValue isKindOfClass:[NSArray class]]) {
                return NO;
            }
            UIColor *color = [UIColor lks_colorFromRGBAComponents:newValue];
            if (!color) {
                return NO;
            }
            setter(color);
            return YES;
        }
            
        case LookinAttrTypeEnumString: {
            NSString *newValue = modification.value;
            if (![newValue isKindOfClass:[NSString class]]) {
                return NO;
            }
            LKS_EnumSetter setter = [[LKS_CustomAttrSetterManager sharedInstance] getEnumSetterWithID:modification.customSetterID];
            if (!setter) {
                return NO;
            }
            setter(newValue);
            return YES;
        }
            
        default:
            return NO;
    }
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
