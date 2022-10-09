//
//  NSArray+Lookin.m
//  Lookin
//
//  Created by Li Kai on 2018/9/3.
//  https://lookin.work
//



#import "NSArray+Lookin.h"

@implementation NSArray (Lookin)

- (NSArray *)lookin_resizeWithCount:(NSUInteger)count add:(id (^)(NSUInteger idx))addBlock remove:(void (^)(NSUInteger idx, id obj))removeBlock doNext:(void (^)(NSUInteger idx, id obj))doBlock {
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        if (self.count > i) {
            id obj = [self objectAtIndex:i];
            [resultArray addObject:obj];
            if (doBlock) {
                doBlock(i, obj);
            }
        } else {
            if (addBlock) {
                id newObj = addBlock(i);
                if (newObj) {
                    [resultArray addObject:newObj];
                    if (doBlock) {
                        doBlock(i, newObj);
                    }
                } else {
                    NSAssert(NO, @"");
                }
            } else {
                NSAssert(NO, @"");
            }
        }
    }
    
    if (removeBlock) {
        if (self.count > count) {
            for (NSUInteger i = count; i < self.count; i++) {
                id obj = [self objectAtIndex:i];
                removeBlock(i, obj);
            }
        }
    }
    
    return [resultArray copy];
}

+ (NSArray *)lookin_arrayWithCount:(NSUInteger)count block:(id (^)(NSUInteger idx))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        id obj = block(i);
        if (obj) {
            [array addObject:obj];
        }
    }
    return [array copy];
}

- (BOOL)lookin_hasIndex:(NSInteger)index {
    if (index == NSNotFound || index < 0) {
        return NO;
    }
    return self.count > index;
}

- (NSArray *)lookin_map:(id (^)(NSUInteger , id))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id newObj = block(idx, obj);
        if (newObj) {
            [array addObject:newObj];
        }
    }];
    return [array copy];
}

- (NSArray *)lookin_filter:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    NSMutableArray *mArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            [mArray addObject:obj];
        }
    }];
    return [mArray copy];
}

- (id)lookin_firstFiltered:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    __block id targetObj = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            targetObj = obj;
            *stop = YES;
        }
    }];
    return targetObj;
}

- (id)lookin_lastFiltered:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    __block id targetObj = nil;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            targetObj = obj;
            *stop = YES;
        }
    }];
    return targetObj;
}

- (id)lookin_reduce:(id (^)(id accumulator, NSUInteger idx, id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return nil;
    }
    
    __block id accumulator = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        accumulator = block(accumulator, idx, obj);
    }];
    return accumulator;
}

- (CGFloat)lookin_reduceCGFloat:(CGFloat (^)(CGFloat accumulator, NSUInteger idx, id obj))block initialAccumlator:(CGFloat)initialAccumlator {
    if (!block) {
        NSAssert(NO, @"");
        return initialAccumlator;
    }
    
    __block CGFloat accumulator = initialAccumlator;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        accumulator = block(accumulator, idx, obj);
    }];
    return accumulator;
}

- (NSInteger)lookin_reduceInteger:(NSInteger (^)(NSInteger, NSUInteger, id))block initialAccumlator:(NSInteger)initialAccumlator {
    if (!block) {
        NSAssert(NO, @"");
        return initialAccumlator;
    }
    
    __block NSInteger accumulator = initialAccumlator;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        accumulator = block(accumulator, idx, obj);
    }];
    return accumulator;
}

- (BOOL)lookin_all:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return NO;
    }
    __block BOOL allPass = YES;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL boolValue = block(obj);
        if (!boolValue) {
            allPass = NO;
            *stop = YES;
        }
    }];
    return allPass;
}

- (BOOL)lookin_any:(BOOL (^)(id obj))block {
    if (!block) {
        NSAssert(NO, @"");
        return NO;
    }
    __block BOOL anyPass = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL boolValue = block(obj);
        if (boolValue) {
            anyPass = YES;
            *stop = YES;
        }
    }];
    return anyPass;
}

- (NSArray *)lookin_arrayByRemovingObject:(id)obj {
    if (!obj || ![self containsObject:obj]) {
        return self;
    }
    NSMutableArray *mutableArray = self.mutableCopy;
    [mutableArray removeObject:obj];
    return mutableArray.copy;
}

- (NSArray *)lookin_nonredundantArray {
    NSSet *set = [NSSet setWithArray:self];
    NSArray *newArray = [set allObjects];
    return newArray;
}

- (id)lookin_safeObjectAtIndex:(NSInteger)idx {
    if (idx == NSNotFound || idx < 0) {
        return nil;
    }
    if (self.count <= idx) {
        return nil;
    }
    return [self objectAtIndex:idx];
}

- (NSArray *)lookin_sortedArrayByStringLength {
    NSArray<NSString *> *sortedArray = [self sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if (obj1.length > obj2.length) {
            return NSOrderedDescending;
        } else if (obj1.length == obj2.length) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
    return sortedArray;
}

@end

@implementation NSMutableArray (Lookin)

- (void)lookin_dequeueWithCount:(NSUInteger)count add:(id (^)(NSUInteger idx))addBlock notDequeued:(void (^)(NSUInteger idx, id obj))notDequeuedBlock doNext:(void (^)(NSUInteger idx, id obj))doBlock {
    for (NSUInteger i = 0; i < count; i++) {
        if ([self lookin_hasIndex:i]) {
            id obj = [self objectAtIndex:i];
            if (doBlock) {
                doBlock(i, obj);
            }
        } else {
            if (addBlock) {
                id newObj = addBlock(i);
                if (newObj) {
                    [self addObject:newObj];
                    if (doBlock) {
                        doBlock(i, newObj);
                    }
                } else {
                    NSAssert(NO, @"");
                }
            } else {
                NSAssert(NO, @"");
            }
        }
    }
    
    if (notDequeuedBlock) {
        if (self.count > count) {
            for (NSUInteger i = count; i < self.count; i++) {
                id obj = [self objectAtIndex:i];
                notDequeuedBlock(i, obj);
            }
        }
    }
}

- (void)lookin_removeObjectsPassingTest:(BOOL (^)(NSUInteger idx, id obj))block {
    if (!block) {
        return;
    }
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull currentObj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL boolValue = block(idx, currentObj);
        if (boolValue) {
            [indexSet addIndex:idx];
        }
    }];
    [self removeObjectsAtIndexes:indexSet];
}

@end
