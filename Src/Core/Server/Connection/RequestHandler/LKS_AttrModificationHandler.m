#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_AttrModificationHandler.m
//  LookinServer
//
//  Created by Li Kai on 2019/6/12.
//  https://lookin.work
//

#import "LKS_AttrModificationHandler.h"
#import "UIColor+LookinServer.h"
#import "LookinAttributeModification.h"
#import "LKS_AttrGroupsMaker.h"
#import "LookinDisplayItemDetail.h"
#import "LookinStaticAsyncUpdateTask.h"
#import "LookinServerDefines.h"

@implementation LKS_AttrModificationHandler

+ (void)handleModification:(LookinAttributeModification *)modification completion:(void (^)(LookinDisplayItemDetail *data, NSError *error))completion {
    if (!completion) {
        NSAssert(NO, @"");
        return;
    }
    if (!modification || ![modification isKindOfClass:[LookinAttributeModification class]]) {
        completion(nil, LookinErr_Inner);
        return;
    }
    
    NSObject *receiver = [NSObject lks_objectWithOid:modification.targetOid];
    if (!receiver) {
        completion(nil, LookinErr_ObjNotFound);
        return;
    }
    
    NSMethodSignature *setterSignature = [receiver methodSignatureForSelector:modification.setterSelector];
    NSInvocation *setterInvocation = [NSInvocation invocationWithMethodSignature:setterSignature];
    setterInvocation.target = receiver;
    setterInvocation.selector = modification.setterSelector;
    
    if (setterSignature.numberOfArguments != 3 || ![receiver respondsToSelector:modification.setterSelector]) {
        completion(nil, LookinErr_Inner);
        return;
    }
    
    switch (modification.attrType) {
        case LookinAttrTypeNone:
        case LookinAttrTypeVoid: {
            completion(nil, LookinErr_Inner);
            return;
        }
        case LookinAttrTypeChar: {
            char expectedValue = [(NSNumber *)modification.value charValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeInt:
        case LookinAttrTypeEnumInt: {
            int expectedValue = [(NSNumber *)modification.value intValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeShort: {
            short expectedValue = [(NSNumber *)modification.value shortValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeLong:
        case LookinAttrTypeEnumLong: {
            long expectedValue = [(NSNumber *)modification.value longValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeLongLong: {
            long long expectedValue = [(NSNumber *)modification.value longLongValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeUnsignedChar: {
            unsigned char expectedValue = [(NSNumber *)modification.value unsignedCharValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeUnsignedInt: {
            unsigned int expectedValue = [(NSNumber *)modification.value unsignedIntValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeUnsignedShort: {
            unsigned short expectedValue = [(NSNumber *)modification.value unsignedShortValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeUnsignedLong: {
            unsigned long expectedValue = [(NSNumber *)modification.value unsignedLongValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeUnsignedLongLong: {
            unsigned long long expectedValue = [(NSNumber *)modification.value unsignedLongLongValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeFloat: {
            float expectedValue = [(NSNumber *)modification.value floatValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeDouble: {
            double expectedValue = [(NSNumber *)modification.value doubleValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeBOOL: {
            BOOL expectedValue = [(NSNumber *)modification.value boolValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeSel: {
            SEL expectedValue = NSSelectorFromString(modification.value);
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeClass: {
            Class expectedValue = NSClassFromString(modification.value);
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeCGPoint: {
            CGPoint expectedValue = [(NSValue *)modification.value CGPointValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeCGVector: {
            CGVector expectedValue = [(NSValue *)modification.value CGVectorValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeCGSize: {
            CGSize expectedValue = [(NSValue *)modification.value CGSizeValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeCGRect: {
            CGRect expectedValue = [(NSValue *)modification.value CGRectValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeCGAffineTransform: {
            CGAffineTransform expectedValue = [(NSValue *)modification.value CGAffineTransformValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeUIEdgeInsets: {
            UIEdgeInsets expectedValue = [(NSValue *)modification.value UIEdgeInsetsValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeUIOffset: {
            UIOffset expectedValue = [(NSValue *)modification.value UIOffsetValue];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            break;
        }
        case LookinAttrTypeCustomObj:
        case LookinAttrTypeNSString: {
            NSObject *expectedValue = modification.value;
            [setterInvocation setArgument:&expectedValue atIndex:2];
            [setterInvocation retainArguments];
            break;
        }
        case LookinAttrTypeUIColor: {
            NSArray<NSNumber *> *rgba = modification.value;
            UIColor *expectedValue = [UIColor lks_colorFromRGBAComponents:rgba];
            [setterInvocation setArgument:&expectedValue atIndex:2];
            [setterInvocation retainArguments];
            break;
        }
        default: {
            completion(nil, LookinErr_Inner);
            return;
        }
    }
    
    NSError *error = nil;
    @try {
        [setterInvocation invoke];
    } @catch (NSException *exception) {
        NSString *errorMsg = [NSString stringWithFormat:LKS_Localized(@"<%@: %p>: an exception was raised when invoking %@. (%@)"), NSStringFromClass(receiver.class), receiver, NSStringFromSelector(modification.setterSelector), exception.reason];
        error = [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_Exception userInfo:@{NSLocalizedDescriptionKey:LKS_Localized(@"The modification may failed."), NSLocalizedRecoverySuggestionErrorKey:errorMsg}];
    } @finally {
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CALayer *layer = nil;
        if ([receiver isKindOfClass:[CALayer class]]) {
            layer = (CALayer *)receiver;
        } else if ([receiver isKindOfClass:[UIView class]]) {
            layer = ((UIView *)receiver).layer;
        } else {
            completion(nil, LookinErr_ObjNotFound);
            return;
        }
        // 比如试图更改 frame 时，这个改动很有可能触发用户业务的 relayout，因此这时 dispatch 一下以确保拿到的 attrGroups 数据是最新的
        LookinDisplayItemDetail *detail = [LookinDisplayItemDetail new];
        detail.displayItemOid = modification.targetOid;
        detail.attributesGroupList = [LKS_AttrGroupsMaker attrGroupsForLayer:layer];
        detail.frameValue = [NSValue valueWithCGRect:layer.frame];
        detail.boundsValue = [NSValue valueWithCGRect:layer.bounds];
        detail.hiddenValue = [NSNumber numberWithBool:layer.isHidden];
        detail.alphaValue = @(layer.opacity);
        completion(detail, error);
    });
}


+ (void)handlePatchWithTasks:(NSArray<LookinStaticAsyncUpdateTask *> *)tasks block:(void (^)(LookinDisplayItemDetail *data))block {
    if (!block) {
        NSAssert(NO, @"");
        return;
    }
    [tasks enumerateObjectsUsingBlock:^(LookinStaticAsyncUpdateTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        LookinDisplayItemDetail *itemDetail = [LookinDisplayItemDetail new];
        itemDetail.displayItemOid = task.oid;
        id object = [NSObject lks_objectWithOid:task.oid];
        if (!object || ![object isKindOfClass:[CALayer class]]) {
            block(itemDetail);
            return;
        }
        
        CALayer *layer = object;
        if (task.taskType == LookinStaticAsyncUpdateTaskTypeSoloScreenshot) {
            UIImage *image = [layer lks_soloScreenshotWithLowQuality:NO];
            itemDetail.soloScreenshot = image;
        } else if (task.taskType == LookinStaticAsyncUpdateTaskTypeGroupScreenshot) {
            UIImage *image = [layer lks_groupScreenshotWithLowQuality:NO];
            itemDetail.groupScreenshot = image;
        }
        block(itemDetail);
    }];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
