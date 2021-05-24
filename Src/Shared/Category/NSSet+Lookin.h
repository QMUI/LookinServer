//
//  NSSet+Lookin.h
//  Lookin
//
//  Created by Li Kai on 2019/1/13.
//  https://lookin.work
//

#import "LookinDefines.h"



#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

@interface NSSet<__covariant ValueType> (Lookin)

- (NSSet *)lookin_map:(id (^)(ValueType obj))block;

- (ValueType)lookin_firstFiltered:(BOOL (^)(ValueType obj))block;

- (NSSet<ValueType> *)lookin_filter:(BOOL (^)(ValueType obj))block;


/**
 是否有任何一个元素满足某条件
 @note 元素将被依次传入 block 里，如果任何一个 block 返回 YES，则该方法返回 YES。如果所有 block 均返回 NO，则该方法返回 NO。
 */
- (BOOL)lookin_any:(BOOL (^)(ValueType obj))block;

@end
