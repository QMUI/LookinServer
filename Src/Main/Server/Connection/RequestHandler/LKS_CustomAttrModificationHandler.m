#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrModificationHandler.m
//  LookinServer
//
//  Created by likaimacbookhome on 2023/11/4.
//

#import "LKS_CustomAttrModificationHandler.h"
#import "LKS_CustomAttrSetterManager.h"

@implementation LKS_CustomAttrModificationHandler

+ (BOOL)handleModification:(LookinCustomAttrModification *)modification {
    if (!modification || modification.customSetterID.length == 0) {
        return NO;
    }
    switch (modification.attrType) {
        case LookinAttrTypeNSString: {
            NSString *newValue = modification.value;
            if (![newValue isKindOfClass:[NSString class]]) {
                return NO;
            }
            LKS_StringSetter setter = [[LKS_CustomAttrSetterManager sharedInstance] getStringSetterWithID:modification.customSetterID];
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
