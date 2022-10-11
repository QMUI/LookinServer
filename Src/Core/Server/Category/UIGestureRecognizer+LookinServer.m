#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIGestureRecognizer+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/8/14.
//  https://lookin.work
//

#import "UIGestureRecognizer+LookinServer.h"
#import <objc/runtime.h>
#import "NSObject+Lookin.h"
#import "LookinTuple.h"
#import "LookinWeakContainer.h"
#import "LookinServerDefines.h"

@implementation UIGestureRecognizer (LookinServer)

#pragma mark - Hook

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod([self class], @selector(initWithTarget:action:));
        Method newMethod = class_getInstanceMethod([self class], @selector(lks_initWithTarget:action:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getInstanceMethod([self class], @selector(addTarget:action:));
        newMethod = class_getInstanceMethod([self class], @selector(lks_addTarget:action:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getInstanceMethod([self class], @selector(removeTarget:action:));
        newMethod = class_getInstanceMethod([self class], @selector(lks_removeTarget:action:));
        method_exchangeImplementations(oriMethod, newMethod);
    });
}

- (instancetype)lks_initWithTarget:(nullable id)target action:(nullable SEL)action {
    UIGestureRecognizer *instance = [self lks_initWithTarget:target action:action];
    [instance lks_didAddTarget:target action:NSStringFromSelector(action)];
    return instance;
}

- (void)lks_addTarget:(id)target action:(SEL)action {
    [self lks_addTarget:target action:action];
    [self lks_didAddTarget:target action:NSStringFromSelector(action)];
}

- (void)lks_removeTarget:(id)target action:(SEL)action {
    [self lks_removeTarget:target action:action];
    [self lks_didRemoveTarget:target action:NSStringFromSelector(action)];
}

#pragma mark - Main

- (void)lks_didAddTarget:(id)target action:(NSString *)action {
    if (!target || !action.length) {
        return;
    }
    BOOL alreadyExist = [self.lks_targetActions lookin_any:^BOOL(LookinTwoTuple *obj) {
        id existTarget = ((LookinWeakContainer *)obj.first).object;
        NSString *existAction = (NSString *)obj.second;
        if (target == existTarget && [action isEqualToString:existAction]) {
            return YES;
        }
        return NO;
    }];
    if (alreadyExist) {
        return;
    }
    LookinTwoTuple *newTuple = [LookinTwoTuple new];
    newTuple.first = [LookinWeakContainer containerWithObject:target];
    newTuple.second = action;
    if (!self.lks_targetActions) {
        self.lks_targetActions = [NSMutableArray array];
    }
    [self.lks_targetActions addObject:newTuple];
}

- (void)lks_didRemoveTarget:(id)target action:(NSString *)action {
    if (target == nil && action == nil) {
        // target 为 nil，action 为 nil 时，表示移除所有 target 的所有已注册监听方法
        [self.lks_targetActions removeAllObjects];
        return;
    }
    
    if (target == nil) {
        // target 为 nil，action 为 handleTap 时，表示移除所有 target 的名为 handleTap 的监听方法
        [self.lks_targetActions lookin_removeObjectsPassingTest:^BOOL(NSUInteger idx, LookinTwoTuple *obj) {
            NSString *currentAction = (NSString *)obj.second;
            if ([currentAction isEqualToString:action]) {
                return YES;
            }
            return NO;
        }];
        return;
    }
    
    if (action == nil) {
        // target 为 abc，action 为 nil 时，表示移除 abc 的所有已注册监听方法
        [self.lks_targetActions lookin_removeObjectsPassingTest:^BOOL(NSUInteger idx, LookinTwoTuple *obj) {
            id currentTarget = ((LookinWeakContainer *)obj.first).object;
            if (currentTarget == target) {
                return YES;
            }
            return NO;
        }];
        return;
    }
    
    [self.lks_targetActions lookin_removeObjectsPassingTest:^BOOL(NSUInteger idx, LookinTwoTuple *obj) {
        id currentTarget = ((LookinWeakContainer *)obj.first).object;
        NSString *currentAction = (NSString *)obj.second;
        if (currentTarget == target && [currentAction isEqualToString:action]) {
            return YES;
        }
        return NO;
    }];
}

- (void)setLks_targetActions:(NSMutableArray<LookinTwoTuple *> *)lks_targetActions {
    [self lookin_bindObject:lks_targetActions forKey:@"lks_targetActions"];
}

- (NSMutableArray *)lks_targetActions {
    return [self lookin_getBindObjectForKey:@"lks_targetActions"];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
