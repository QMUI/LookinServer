#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  NSSet+Lookin.m
//  Lookin
//
//  Created by Li Kai on 2019/1/13.
//  https://lookin.work
//



#import "NSSet+Lookin.h"

@implementation NSSet (Lookin)

- (NSSet *)lookin_map:(id (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    NSMutableSet *newSet = [NSMutableSet setWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        id newObj = block(obj);
        if (newObj) {
            [newSet addObject:newObj];
        }
    }];
    return [newSet copy];
}

- (id)lookin_firstFiltered:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    __block id targetObj = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(obj)) {
            targetObj = obj;
            *stop = YES;
        }
    }];
    return targetObj;
}

- (NSSet *)lookin_filter:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    NSMutableSet *mSet = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(obj)) {
            [mSet addObject:obj];
        }
    }];
    return [mSet copy];
}

- (BOOL)lookin_any:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return NO;
    }
    __block BOOL boolValue = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(obj)) {
            boolValue = YES;
            *stop = YES;
        }
    }];
    return boolValue;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
