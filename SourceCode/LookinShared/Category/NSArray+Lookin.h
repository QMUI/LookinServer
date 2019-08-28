//
//  NSArray+Lookin.h
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSArray<__covariant ValueType> (Lookin)

/**
 初始化一个新的 NSArray 并返回，新数组的长度为 count，如果当前数组长度比 count 小则会补充新元素（被补充的元素由 addBlock 返回），如果当前数组长度比 count 大则会舍弃多余的元素，被舍弃的元素会作为参数传入 removeBlock。最终，新数组的所有元素均会作为参数被传入 doBlock。
 */
- (NSArray<ValueType> *)resizeWithCount:(NSUInteger)count add:(ValueType (^)(NSUInteger idx))addBlock remove:(void (^)(NSUInteger idx, ValueType obj))removeBlock doNext:(void (^)(NSUInteger idx, ValueType obj))doBlock __attribute__((warn_unused_result));

+ (NSArray *)arrayWithCount:(NSUInteger)count block:(id (^)(NSUInteger idx))block;

/**
 检查 index 位置是否有元素存在
 */
- (BOOL)hasIndex:(NSInteger)index;

- (NSArray *)lookin_map:(id (^)(NSUInteger idx, ValueType value))block;

- (NSArray<ValueType> *)lookin_filter:(BOOL (^)( ValueType obj))block;

- (ValueType)firstFiltered:(BOOL (^)(ValueType obj))block;

/// 返回最后一个 block 返回 YES 的元素
- (ValueType)lookin_lastFiltered:(BOOL (^)(ValueType obj))block;

- (id)lookin_reduce:(id (^)(id accumulator, NSUInteger idx, ValueType obj))block;

- (CGFloat)lookin_reduceCGFloat:(CGFloat (^)(CGFloat accumulator, NSUInteger idx, ValueType obj))block initialAccumlator:(CGFloat)initialAccumlator;
- (NSInteger)lookin_reduceInteger:(NSInteger (^)(NSInteger accumulator, NSUInteger idx, ValueType obj))block initialAccumlator:(NSInteger)initialAccumlator;

- (BOOL)all:(BOOL (^)(ValueType obj))block;

- (BOOL)lookin_any:(BOOL (^)(ValueType obj))block;

- (NSArray<ValueType> *)lookin_arrayByRemovingObject:(ValueType)obj;

- (NSArray<ValueType> *)lookin_nonredundantArray;

- (ValueType)lookin_safeObjectAtIndex:(NSInteger)idx;

/// 字符串长度从短到长，即 length 小的字符串的 idx 更小
- (NSArray<ValueType> *)lookin_sortedArrayByStringLength;

@end
