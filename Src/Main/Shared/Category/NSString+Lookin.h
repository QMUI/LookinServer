#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  NSString+Lookin.h
//  Lookin
//
//  Created by Li Kai on 2019/5/11.
//  https://lookin.work
//

#import "LookinDefines.h"



#import <Foundation/Foundation.h>

@interface NSString (Lookin)

/**
 把 CGFloat 转成字符串，最多保留 3 位小数，转换后末尾的 0 会被删除
 如：1.2341 => @"1.234", 2.1002 => @"2.1", 3.000 => @"3"
 */
+ (NSString *)lookin_stringFromDouble:(double)doubleValue decimal:(NSUInteger)decimal;

+ (NSString *)lookin_stringFromRect:(CGRect)rect;

+ (NSString *)lookin_stringFromInset:(LookinInsets)insets;

+ (NSString *)lookin_stringFromSize:(CGSize)size;

+ (NSString *)lookin_stringFromPoint:(CGPoint)point;

+ (NSString *)lookin_rgbaStringFromColor:(LookinColor *)color;

- (NSString *)lookin_safeInitWithUTF8String:(const char *)string;

/// 在 swift 中，类名可能会被加前缀，比如 MyApp.MyView 或 _TtC5MyApp8TestView 这种，该方法会返回简化后的末尾的类名，比如 MyView
- (NSString *)lookin_shortClassNameString;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
