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

@implementation LKS_EventHandlerMaker

+ (NSArray<LookinEventHandler *> *)makeForView:(UIView *)view {
    if (!view) {
        return nil;
    }
    
    NSMutableArray<LookinEventHandler *> *allHandlers = nil;
    
    if ([view isKindOfClass:[UIControl class]]) {
        NSArray<LookinEventHandler *> *targetActionHandlers = [self _targetActionHandlersForControl:(UIControl *)view];
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

+ (NSArray<LookinEventHandler *> *)_gestureHandlersForView:(UIView *)view {
    if (view.gestureRecognizers.count == 0) {
        return nil;
    }
    NSArray<LookinEventHandler *> *handlers = [view.gestureRecognizers lookin_map:^id(NSUInteger idx, __kindof UIGestureRecognizer *recognizer) {
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

+ (NSString *)_inheritedRecognizerNameForRecognizer:(UIGestureRecognizer *)recognizer {
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
#else
        baseRecognizers = @[[UILongPressGestureRecognizer class],
                            [UIScreenEdgePanGestureRecognizer class],
                            [UIPanGestureRecognizer class],
                            [UISwipeGestureRecognizer class],
                            [UIRotationGestureRecognizer class],
                            [UIPinchGestureRecognizer class],
                            [UITapGestureRecognizer class]];
#endif

    });
    
    __block NSString *result = @"UIGestureRecognizer";
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

+ (NSArray<LookinEventHandler *> *)_targetActionHandlersForControl:(UIControl *)control {
    static dispatch_once_t onceToken;
    static NSArray<NSNumber *> *allEvents = nil;
    dispatch_once(&onceToken,^{
        allEvents = @[@(UIControlEventTouchDown), @(UIControlEventTouchDownRepeat), @(UIControlEventTouchDragInside), @(UIControlEventTouchDragOutside), @(UIControlEventTouchDragEnter), @(UIControlEventTouchDragExit), @(UIControlEventTouchUpInside), @(UIControlEventTouchUpOutside), @(UIControlEventTouchCancel), @(UIControlEventValueChanged), @(UIControlEventEditingDidBegin), @(UIControlEventEditingChanged), @(UIControlEventEditingDidEnd), @(UIControlEventEditingDidEndOnExit)];
        if (@available(iOS 9.0, *)) {
            allEvents = [allEvents arrayByAddingObject:@(UIControlEventPrimaryActionTriggered)];
        }
    });

    NSSet *allTargets = control.allTargets;
    
    if (!allTargets.count) {
        return nil;
    }
    
    NSMutableArray<LookinEventHandler *> *handlers = [NSMutableArray array];
    
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
    
    return handlers;
}

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

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
