#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_EventHandlerMaker.m
//  LookinServer
//
//  Created by Li Kai on 2019/8/7.
//  https://lookin.work
//

#import "LKS_EventHandlerMaker.h"
#import "LookinTuple.h"
#import "LookinEventHandler.h"
#import "LookinObject.h"
#import "LookinWeakContainer.h"
#import "LookinIvarTrace.h"
#import "LookinServerDefines.h"
#import "LKS_GestureTargetActionsSearcher.h"
#import "LKS_MultiplatformAdapter.h"

@implementation LKS_EventHandlerMaker

+ (NSArray<LookinEventHandler *> *)makeForView:(LookinView *)view {
    if (!view) {
        return nil;
    }
    
    NSMutableArray<LookinEventHandler *> *allHandlers = nil;
    if ([view isKindOfClass:[LookinControl class]]) {
        NSArray<LookinEventHandler *> *targetActionHandlers = [self _targetActionHandlersForControl:(LookinControl *)view];
        if (targetActionHandlers.count) {
            if (!allHandlers) {
                allHandlers = [NSMutableArray array];
            }
            [allHandlers addObjectsFromArray:targetActionHandlers];
        }
    }
    
    NSArray<LookinEventHandler *> *gestureHandlers = [self _gestureHandlersForView:view];
    if (gestureHandlers.count) {
        if (!allHandlers) {
            allHandlers = [NSMutableArray array];
        }
        [allHandlers addObjectsFromArray:gestureHandlers];
    }
    
    return allHandlers.copy;
}

+ (NSArray<LookinEventHandler *> *)_gestureHandlersForView:(LookinView *)view {
    if (view.gestureRecognizers.count == 0) {
        return nil;
    }
    NSArray<LookinEventHandler *> *handlers = [view.gestureRecognizers lookin_map:^id(NSUInteger idx, __kindof LookinGestureRecognizer *recognizer) {
        LookinEventHandler *handler = [LookinEventHandler new];
        handler.handlerType = LookinEventHandlerTypeGesture;
        handler.eventName = NSStringFromClass([recognizer class]);
        
        NSArray<LookinTwoTuple *> *targetActionInfos = [LKS_GestureTargetActionsSearcher getTargetActionsFromRecognizer:recognizer];
        handler.targetActions = [targetActionInfos lookin_map:^id(NSUInteger idx, LookinTwoTuple *rawTuple) {
            NSObject *target = ((LookinWeakContainer *)rawTuple.first).object;
            if (!target) {
                // 该 target 已被释放
                return nil;
            }
            LookinStringTwoTuple *newTuple = [LookinStringTwoTuple new];
            newTuple.first = [LKS_Helper descriptionOfObject:target];
            newTuple.second = (NSString *)rawTuple.second;
            return newTuple;
        }];
        handler.inheritedRecognizerName = [self _inheritedRecognizerNameForRecognizer:recognizer];
        handler.gestureRecognizerIsEnabled = recognizer.enabled;
        if (recognizer.delegate) {
            handler.gestureRecognizerDelegator = [LKS_Helper descriptionOfObject:recognizer.delegate];
        }
        handler.recognizerIvarTraces = [recognizer.lks_ivarTraces lookin_map:^id(NSUInteger idx, LookinIvarTrace *trace) {
            return [NSString stringWithFormat:@"(%@ *) -> %@", trace.hostClassName, trace.ivarName];
        }];
        
        handler.recognizerOid = [recognizer lks_registerOid];
        return handler;
    }];
    return handlers;
}

+ (NSString *)_inheritedRecognizerNameForRecognizer:(LookinGestureRecognizer *)recognizer {
    if (!recognizer) {
        NSAssert(NO, @"");
        return nil;
    }
    
    static NSArray<Class> *baseRecognizers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 注意这里 UIScreenEdgePanGestureRecognizer 在 UIPanGestureRecognizer 前面，因为 UIScreenEdgePanGestureRecognizer 继承于 UIPanGestureRecognizer
#if TARGET_OS_TV
        baseRecognizers = @[[UILongPressGestureRecognizer class],
                            [UIPanGestureRecognizer class],
                            [UISwipeGestureRecognizer class],
                            [UITapGestureRecognizer class]];
#elif TARGET_OS_VISION
        baseRecognizers = @[[UILongPressGestureRecognizer class],
                            [UIPanGestureRecognizer class],
                            [UISwipeGestureRecognizer class],
                            [UIRotationGestureRecognizer class],
                            [UIPinchGestureRecognizer class],
                            [UITapGestureRecognizer class]];
#elif TARGET_OS_IPHONE
        baseRecognizers = @[[UILongPressGestureRecognizer class],
                            [UIScreenEdgePanGestureRecognizer class],
                            [UIPanGestureRecognizer class],
                            [UISwipeGestureRecognizer class],
                            [UIRotationGestureRecognizer class],
                            [UIPinchGestureRecognizer class],
                            [UITapGestureRecognizer class]];
#elif TARGET_OS_OSX
        baseRecognizers = @[[NSClickGestureRecognizer class],
                            [NSMagnificationGestureRecognizer class],
                            [NSPanGestureRecognizer class],
                            [NSPressGestureRecognizer class],
                            [NSRotationGestureRecognizer class]];
#else
        baseRecognizers = @[];
#endif

    });
    
#if TARGET_OS_IPHONE
    __block NSString *result = @"UIGestureRecognizer";
#elif TARGET_OS_OSX
    __block NSString *result = @"NSGestureRecognizer";
#endif
    
    
    [baseRecognizers enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([recognizer isMemberOfClass:obj]) {
            // 自身就是基本款，则直接置为 nil
            result = nil;
            *stop = YES;
            return;
        }
        if ([recognizer isKindOfClass:obj]) {
            result = NSStringFromClass(obj);
            *stop = YES;
            return;
        }
    }];
    return result;
}

+ (NSArray<LookinEventHandler *> *)_targetActionHandlersForControl:(LookinControl *)control {
    static dispatch_once_t onceToken;
    static NSArray<NSNumber *> *allEvents = nil;
    dispatch_once(&onceToken,^{
#if TARGET_OS_IPHONE
        allEvents = @[@(UIControlEventTouchDown), @(UIControlEventTouchDownRepeat), @(UIControlEventTouchDragInside), @(UIControlEventTouchDragOutside), @(UIControlEventTouchDragEnter), @(UIControlEventTouchDragExit), @(UIControlEventTouchUpInside), @(UIControlEventTouchUpOutside), @(UIControlEventTouchCancel), @(UIControlEventValueChanged), @(UIControlEventEditingDidBegin), @(UIControlEventEditingChanged), @(UIControlEventEditingDidEnd), @(UIControlEventEditingDidEndOnExit)];
        if (@available(iOS 9.0, *)) {
            allEvents = [allEvents arrayByAddingObject:@(UIControlEventPrimaryActionTriggered)];
        }
#elif TARGET_OS_OSX
        allEvents = @[
            @(NSEventMaskLeftMouseDown),
            @(NSEventMaskLeftMouseUp),
            @(NSEventMaskRightMouseDown),
            @(NSEventMaskRightMouseUp),
            @(NSEventMaskMouseMoved),
            @(NSEventMaskLeftMouseDragged),
            @(NSEventMaskRightMouseDragged),
            @(NSEventMaskMouseEntered),
            @(NSEventMaskMouseExited),
            @(NSEventMaskKeyDown),
            @(NSEventMaskKeyUp),
            @(NSEventMaskFlagsChanged),
            @(NSEventMaskAppKitDefined),
            @(NSEventMaskSystemDefined),
            @(NSEventMaskApplicationDefined),
            @(NSEventMaskPeriodic),
            @(NSEventMaskCursorUpdate),
            @(NSEventMaskScrollWheel),
            @(NSEventMaskTabletPoint),
            @(NSEventMaskTabletProximity),
            @(NSEventMaskOtherMouseDown),
            @(NSEventMaskOtherMouseUp),
            @(NSEventMaskOtherMouseDragged),
            @(NSEventMaskGesture),
            @(NSEventMaskMagnify),
            @(NSEventMaskSwipe),
            @(NSEventMaskRotate),
            @(NSEventMaskBeginGesture),
            @(NSEventMaskEndGesture),
            @(NSEventMaskSmartMagnify),
            @(NSEventMaskPressure),
            @(NSEventMaskDirectTouch),
            @(NSEventMaskAny),
        ];
        if (@available(macOS 10.15, *)) {
            allEvents = [allEvents arrayByAddingObject:@(NSEventMaskChangeMode)];
        }
#endif
    });

#if TARGET_OS_IPHONE
    NSSet *allTargets = control.allTargets;
#elif TARGET_OS_OSX
    NSMutableSet *allTargets = [NSMutableSet set];
    if (control.target) {
        [allTargets addObject:control.target];
    }
#endif
    
    if (!allTargets.count) {
        return nil;
    }
    
    NSMutableArray<LookinEventHandler *> *handlers = [NSMutableArray array];
    
#if TARGET_OS_IPHONE
    [allEvents enumerateObjectsUsingBlock:^(NSNumber * _Nonnull eventNum, NSUInteger idx, BOOL * _Nonnull stop) {
        UIControlEvents event = [eventNum unsignedIntegerValue];
        NSMutableArray<LookinStringTwoTuple *> *targetActions = [NSMutableArray array];
        
        [allTargets enumerateObjectsUsingBlock:^(id  _Nonnull target, BOOL * _Nonnull stop) {
            NSArray<NSString *> *actions = [control actionsForTarget:target forControlEvent:event];
            [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
                LookinStringTwoTuple *tuple = [LookinStringTwoTuple new];
                tuple.first = [LKS_Helper descriptionOfObject:target];
                tuple.second = action;
                [targetActions addObject:tuple];
            }];
        }];
        
        if (targetActions.count) {
            LookinEventHandler *handler = [LookinEventHandler new];
            handler.handlerType = LookinEventHandlerTypeTargetAction;
            handler.eventName = [self _nameFromControlEvent:event];
            handler.targetActions = targetActions.copy;
            [handlers addObject:handler];
        }
    }];
#elif TARGET_OS_OSX
    if (control.target && control.action) {
        NSEventMask eventMask = [[control valueForKeyPath:@"cell.sendActionOnMask"] unsignedIntegerValue];
        LookinEventHandler *handler = [LookinEventHandler new];
        handler.handlerType = LookinEventHandlerTypeTargetAction;
        handler.eventName = [self _nameFromEventMask:eventMask];
        handler.targetActions = @[[LookinStringTwoTuple tupleWithFirst:[LKS_Helper descriptionOfObject:control.target] second:NSStringFromSelector(control.action)]];
        [handlers addObject:handler];
    }
#endif
    
    return handlers;
}

#if TARGET_OS_IPHONE
+ (NSString *)_nameFromControlEvent:(UIControlEvents)event {
    static dispatch_once_t onceToken;
    static NSDictionary<NSNumber *, NSString *> *eventsAndNames = nil;
    dispatch_once(&onceToken,^{
        NSMutableDictionary<NSNumber *, NSString *> *eventsAndNames_m = @{
            @(UIControlEventTouchDown): @"UIControlEventTouchDown",
            @(UIControlEventTouchDownRepeat): @"UIControlEventTouchDownRepeat",
            @(UIControlEventTouchDragInside): @"UIControlEventTouchDragInside",
            @(UIControlEventTouchDragOutside): @"UIControlEventTouchDragOutside",
            @(UIControlEventTouchDragEnter): @"UIControlEventTouchDragEnter",
            @(UIControlEventTouchDragExit): @"UIControlEventTouchDragExit",
            @(UIControlEventTouchUpInside): @"UIControlEventTouchUpInside",
            @(UIControlEventTouchUpOutside): @"UIControlEventTouchUpOutside",
            @(UIControlEventTouchCancel): @"UIControlEventTouchCancel",
            @(UIControlEventValueChanged): @"UIControlEventValueChanged",
            @(UIControlEventEditingDidBegin): @"UIControlEventEditingDidBegin",
            @(UIControlEventEditingChanged): @"UIControlEventEditingChanged",
            @(UIControlEventEditingDidEnd): @"UIControlEventEditingDidEnd",
            @(UIControlEventEditingDidEndOnExit): @"UIControlEventEditingDidEndOnExit",
        }.mutableCopy;
        if (@available(iOS 9.0, *)) {
            eventsAndNames_m[@(UIControlEventPrimaryActionTriggered)] = @"UIControlEventPrimaryActionTriggered";
        }
        eventsAndNames = eventsAndNames_m.copy;
    });
    
    NSString *name = eventsAndNames[@(event)];
    return name;
}
#elif TARGET_OS_OSX
+ (NSString *)_nameFromEventMask:(NSEventMask)eventMask {
    static dispatch_once_t onceToken;
    static NSDictionary<NSNumber *, NSString *> *eventsAndNames = nil;
    dispatch_once(&onceToken,^{
        NSMutableDictionary<NSNumber *, NSString *> *eventsAndNames_m = @{
            @(NSEventMaskLeftMouseDown): @"NSEventMaskLeftMouseDown",
            @(NSEventMaskLeftMouseUp): @"NSEventMaskLeftMouseUp",
            @(NSEventMaskRightMouseDown): @"NSEventMaskRightMouseDown",
            @(NSEventMaskRightMouseUp): @"NSEventMaskRightMouseUp",
            @(NSEventMaskMouseMoved): @"NSEventMaskMouseMoved",
            @(NSEventMaskLeftMouseDragged): @"NSEventMaskLeftMouseDragged",
            @(NSEventMaskRightMouseDragged): @"NSEventMaskRightMouseDragged",
            @(NSEventMaskMouseEntered): @"NSEventMaskMouseEntered",
            @(NSEventMaskMouseExited): @"NSEventMaskMouseExited",
            @(NSEventMaskKeyDown): @"NSEventMaskKeyDown",
            @(NSEventMaskKeyUp): @"NSEventMaskKeyUp",
            @(NSEventMaskFlagsChanged): @"NSEventMaskFlagsChanged",
            @(NSEventMaskAppKitDefined): @"NSEventMaskAppKitDefined",
            @(NSEventMaskSystemDefined): @"NSEventMaskSystemDefined",
            @(NSEventMaskApplicationDefined): @"NSEventMaskApplicationDefined",
            @(NSEventMaskPeriodic): @"NSEventMaskPeriodic",
            @(NSEventMaskCursorUpdate): @"NSEventMaskCursorUpdate",
            @(NSEventMaskScrollWheel): @"NSEventMaskScrollWheel",
            @(NSEventMaskTabletPoint): @"NSEventMaskTabletPoint",
            @(NSEventMaskTabletProximity): @"NSEventMaskTabletProximity",
            @(NSEventMaskOtherMouseDown): @"NSEventMaskOtherMouseDown",
            @(NSEventMaskOtherMouseUp): @"NSEventMaskOtherMouseUp",
            @(NSEventMaskOtherMouseDragged): @"NSEventMaskOtherMouseDragged",
            @(NSEventMaskGesture): @"NSEventMaskGesture",
            @(NSEventMaskMagnify): @"NSEventMaskMagnify",
            @(NSEventMaskSwipe): @"NSEventMaskSwipe",
            @(NSEventMaskRotate): @"NSEventMaskRotate",
            @(NSEventMaskBeginGesture): @"NSEventMaskBeginGesture",
            @(NSEventMaskEndGesture): @"NSEventMaskEndGesture",
            @(NSEventMaskSmartMagnify): @"NSEventMaskSmartMagnify",
            @(NSEventMaskPressure): @"NSEventMaskPressure",
            @(NSEventMaskDirectTouch): @"NSEventMaskDirectTouch",
            @(NSEventMaskAny): @"NSEventMaskAny",
        }.mutableCopy;
        if (@available(macOS 10.15, *)) {
            eventsAndNames_m[@(NSEventMaskChangeMode)] = @"NSEventMaskChangeMode";
        }
        eventsAndNames = eventsAndNames_m.copy;
    });
    
    NSString *name = eventsAndNames[@(eventMask)];
    return name;
}
#endif

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
