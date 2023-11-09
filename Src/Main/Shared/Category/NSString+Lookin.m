#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  NSString+Lookin.m
//  Lookin
//
//  Created by Li Kai on 2019/5/11.
//  https://lookin.work
//



#import "NSString+Lookin.h"

@implementation NSString (Lookin)

+ (NSString *)lookin_stringFromDouble:(double)doubleValue decimal:(NSUInteger)decimal {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(decimal)];
    NSString *string = [NSString stringWithFormat:formatString, doubleValue];
    for (int i = 0; i < decimal; i++) {
        if ([[string substringFromIndex:string.length - 1] isEqualToString:@"0"]) {
            string = [string substringToIndex:string.length - 1];
        }
    }
    if ([[string substringFromIndex:string.length - 1] isEqualToString:@"."]) {
        string = [string substringToIndex:string.length - 1];
    }
    return string;
}

+ (NSString *)lookin_stringFromInset:(LookinInsets)insets {
    return [NSString stringWithFormat:@"{%@, %@, %@, %@}",
            [NSString lookin_stringFromDouble:insets.top decimal:2],
            [NSString lookin_stringFromDouble:insets.left decimal:2],
            [NSString lookin_stringFromDouble:insets.bottom decimal:2],
            [NSString lookin_stringFromDouble:insets.right decimal:2]];
}

+ (NSString *)lookin_stringFromSize:(CGSize)size {
    return [NSString stringWithFormat:@"{%@, %@}",
            [NSString lookin_stringFromDouble:size.width decimal:2],
            [NSString lookin_stringFromDouble:size.height decimal:2]];
}


+ (NSString *)lookin_stringFromPoint:(CGPoint)point {
    return [NSString stringWithFormat:@"{%@, %@}",
            [NSString lookin_stringFromDouble:point.x decimal:2],
            [NSString lookin_stringFromDouble:point.y decimal:2]];
}

+ (NSString *)lookin_stringFromRect:(CGRect)rect {
    return [NSString stringWithFormat:@"{%@, %@, %@, %@}",
            [NSString lookin_stringFromDouble:rect.origin.x decimal:2],
            [NSString lookin_stringFromDouble:rect.origin.y decimal:2],
            [NSString lookin_stringFromDouble:rect.size.width decimal:2],
            [NSString lookin_stringFromDouble:rect.size.height decimal:2]];
}

+ (NSString *)lookin_rgbaStringFromColor:(LookinColor *)color {
    if (!color) {
        return @"nil";
    }
    
#if TARGET_OS_IPHONE
    UIColor *rgbColor = color;
#elif TARGET_OS_MAC
    NSColor *rgbColor = [color colorUsingColorSpace:NSColorSpace.sRGBColorSpace];
#endif
    
    CGFloat r, g, b, a;
    [rgbColor getRed:&r green:&g blue:&b alpha:&a];
    
    NSString *colorDesc;
    if (a >= 1) {
        colorDesc = [NSString stringWithFormat:@"(%.0f, %.0f, %.0f)", r * 255, g * 255, b * 255];
    } else {
        colorDesc = [NSString stringWithFormat:@"(%.0f, %.0f, %.0f, %@)", r * 255, g * 255, b * 255, [NSString lookin_stringFromDouble:a decimal:2]];
        
    }
    
    return colorDesc;
}

- (NSString *)lookin_safeInitWithUTF8String:(const char *)string {
    if (NULL != string) {
        return [self initWithUTF8String:string];
    }
    return nil;
}

- (NSString *)lookin_shortClassNameString {
    if ([self containsString:@"."]) {
        // Swift 中，class 可能会被加前缀，比如 Weread.AvatarView，此时返回后半部分即可
        NSString *shortName = [self componentsSeparatedByString:@"."].lastObject;
        return shortName;
    }
    if ([self hasPrefix:@"_Tt"]) {
        // Swift 中，private class 可能会被加前缀，比如 MyApp 里一个叫 TestView 的 private class，这里获取到的可能是：_TtC5MyAppP33_6BC07D230B8F25989003315CA1D8100B8TestView
        // 这里规则比较复杂，可以参考这里的讨论：https://stackoverflow.com/questions/24062957/swift-objective-c-runtime-class-naming
        // _Tt 开头则认为是这种类型
        for (NSInteger i = self.length - 1; i >= 0; i--) {
            // 比如上面的注释里的例子，末尾的 TestView 即我们想截取的字符串，而它前面的那个数字 8 则是分隔符，8 在这里表示 TestView 字符串的长度是 8
            // 这里是倒序从最后一个字母向前遍历，i 为当前被遍历到的字符串的 idx，比如遍历到 "_" 时则 i 为 0
            
            // 当前已经被遍历到的末尾字符串的数量，比如第八次执行该循环时，enumeratedStringLength 为 8
            NSInteger enumeratedStringLength = self.length - i;
            
            // 我们此刻检查下一次将会被遍历到的那一个（或两个）字符串是否是对应的数字 8，如果是，则认为当前被遍历过的字符串是我们要找的类名
            
            // 要检查接下来多少位的字符串是否是数字，比如 enumeratedStringLength 为 8 时则检查接下来的 1 位字符串是否是 8，如果 enumeratedStringLength 为 12 则检查接下来的 2 位数字是否是 12
            NSInteger numberLengthToCheck = 1;
            if (enumeratedStringLength >= 10) {
                numberLengthToCheck = 2;
            } else if (enumeratedStringLength >= 100) {
                numberLengthToCheck = 3;
            }
            
            if (i < numberLengthToCheck) {
                // 全部检查完了，失败，直接返回自身吧
                return self;
            }
            
            NSRange checkRange = NSMakeRange(i - numberLengthToCheck, numberLengthToCheck);
            NSString *stringToCheck = [self substringWithRange:checkRange];
            NSInteger scannedNumber = [stringToCheck integerValue];
            if (scannedNumber == enumeratedStringLength) {
                // 比如我们已经遍历到了 “TextView”，而下一个字母确实就是数字 8，则这里我们认为找到了目标字符串
                NSString *targetString = [self substringFromIndex:i];
                return targetString;
            }
            // 继续遍历
        }
    }
    return self;
}

- (NSInteger)lookin_numbericOSVersion {
    if (self.length == 0) {
        NSAssert(NO, @"");
        return 0;
    }
    NSArray *versionArr = [self componentsSeparatedByString:@"."];
    if (versionArr.count != 3) {
        NSAssert(NO, @"");
        return 0;
    }
    
    NSInteger numbericOSVersion = 0;
    NSInteger pos = 0;
    
    while ([versionArr count] > pos && pos < 3) {
        numbericOSVersion += ([[versionArr objectAtIndex:pos] integerValue] * pow(10, (4 - pos * 2)));
        pos++;
    }
    
    return numbericOSVersion;
}


@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
