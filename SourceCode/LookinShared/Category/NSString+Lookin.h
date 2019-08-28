//
//  NSString+Lookin.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LookinDefines.h"

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

@end
