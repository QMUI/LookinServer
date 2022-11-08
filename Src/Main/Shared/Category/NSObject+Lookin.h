#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  NSObject+Lookin.h
//  Lookin
//
//  Created by Li Kai on 2018/12/22.
//  https://lookin.work
//

#import "LookinDefines.h"



#import <Foundation/Foundation.h>
#import "LookinCodingValueType.h"

@interface NSObject (Lookin)

#pragma mark - Data Bind

/**
 给对象绑定上另一个对象以供后续取出使用，如果 object 传入 nil 则会清除该 key 之前绑定的对象
 
 @attention 被绑定的对象会被 strong 强引用
 @note 内部是使用 objc_setAssociatedObject / objc_getAssociatedObject 来实现
 
 @code
 - (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath {
 // 1）在这里给 button 绑定上 indexPath 对象
 [cell lookin_bindObject:indexPath forKey:@"indexPath"];
 }
 
 - (void)didTapButton:(UIButton *)button {
 // 2）在这里取出被点击的 button 的 indexPath 对象
 NSIndexPath *indexPathTapped = [button lookin_getBindObjectForKey:@"indexPath"];
 }
 @endcode
 */
- (void)lookin_bindObject:(id)object forKey:(NSString *)key;

/**
 给对象绑定上另一个对象以供后续取出使用，但相比于 lookin_bindObject:forKey:，该方法不会 strong 强引用传入的 object
 */
- (void)lookin_bindObjectWeakly:(id)object forKey:(NSString *)key;

/**
 取出之前使用 bind 方法绑定的对象
 */
- (id)lookin_getBindObjectForKey:(NSString *)key;

/**
 给对象绑定上一个 double 值以供后续取出使用
 */
- (void)lookin_bindDouble:(double)doubleValue forKey:(NSString *)key;

/**
 取出之前用 lookin_bindDouble:forKey: 绑定的值
 */
- (double)lookin_getBindDoubleForKey:(NSString *)key;

/**
 给对象绑定上一个 BOOL 值以供后续取出使用
 */
- (void)lookin_bindBOOL:(BOOL)boolValue forKey:(NSString *)key;

/**
 取出之前用 lookin_bindBOOL:forKey: 绑定的值
 */
- (BOOL)lookin_getBindBOOLForKey:(NSString *)key;

/**
 给对象绑定上一个 long 值以供后续取出使用
 */
- (void)lookin_bindLong:(long)longValue forKey:(NSString *)key;

/**
 取出之前用 lookin_bindLong:forKey: 绑定的值
 */
- (long)lookin_getBindLongForKey:(NSString *)key;

/**
 给对象绑定上一个 CGPoint 值以供后续取出使用
 */
- (void)lookin_bindPoint:(CGPoint)pointValue forKey:(NSString *)key;

/**
 取出之前用 lookin_bindPoint:forKey: 绑定的值
 */
- (CGPoint)lookin_getBindPointForKey:(NSString *)key;

/**
 移除之前使用 bind 方法绑定的对象
 */
- (void)lookin_clearBindForKey:(NSString *)key;

@end

@interface NSObject (Lookin_Coding)

/// 会把 NSImage/UIImage 转换为 NSData，把 NSColor/UIColor 转换回 NSNumber 数组(rgba)
- (id)lookin_encodedObjectWithType:(LookinCodingValueType)type;
/// 会把 NSData 转换回 NSImage/UIImage，把 NSNumber 数组(rgba) 转换为 NSColor/UIColor
- (id)lookin_decodedObjectWithType:(LookinCodingValueType)type;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
