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

/// 把 1.2.3 这种 String 版本号转换成数字，可用于大小比较，如 110205 代表 11.2.5 版本
- (NSInteger)lookin_numbericOSVersion;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
