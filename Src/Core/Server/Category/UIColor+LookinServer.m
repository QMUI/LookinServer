//
//  UIColor+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/6/5.
//  https://lookin.work
//

#import "UIColor+LookinServer.h"

@implementation UIColor (LookinServer)

- (NSArray<NSNumber *> *)lks_rgbaComponents {
    CGFloat r, g, b, a;
    CGColorRef cgColor = [self CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    if (CGColorGetNumberOfComponents(cgColor) == 4) {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    } else if (CGColorGetNumberOfComponents(cgColor) == 2) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    } else if (CGColorGetNumberOfComponents(cgColor) == 1) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[0];
    } else {
        r = 0;
        g = 0;
        b = 0;
        a = 0;
        NSAssert(NO, @"");
    }
    NSArray<NSNumber *> *rgba = @[@(r), @(g), @(b), @(a)];
    return rgba;
}

+ (instancetype)lks_colorFromRGBAComponents:(NSArray<NSNumber *> *)components {
    if (!components) {
        return nil;
    }
    if (components.count != 4) {
        NSAssert(NO, @"");
        return nil;
    }
    UIColor *color = [UIColor colorWithRed:components[0].doubleValue green:components[1].doubleValue blue:components[2].doubleValue alpha:components[3].doubleValue];
    return color;
}

- (NSString *)lks_rgbaString {
    CGFloat r, g, b, a;
    CGColorRef cgColor = [self CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    if (CGColorGetNumberOfComponents(cgColor) == 4) {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    } else if (CGColorGetNumberOfComponents(cgColor) == 2) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    } else {
        r = 0;
        g = 0;
        b = 0;
        a = 0;
        NSAssert(NO, @"");
    }
    
    if (a >= 1) {
        return [NSString stringWithFormat:@"(%.0f, %.0f, %.0f)", r * 255, g * 255, b * 255];
    } else {
        return [NSString stringWithFormat:@"(%.0f, %.0f, %.0f, %.2f)", r * 255, g * 255, b * 255, a];
    }
}

- (NSString *)lks_hexString {
    CGFloat r, g, b, a;
    CGColorRef cgColor = [self CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    if (CGColorGetNumberOfComponents(cgColor) == 4) {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    } else if (CGColorGetNumberOfComponents(cgColor) == 2) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    } else {
        r = 0;
        g = 0;
        b = 0;
        a = 0;
        NSAssert(NO, @"");
    }
    
    NSInteger red = r * 255;
    NSInteger green = g * 255;
    NSInteger blue = b * 255;
    NSInteger alpha = a * 255;
    
    return [[NSString stringWithFormat:@"#%@%@%@%@",
             [UIColor _alignColorHexStringLength:[UIColor _hexStringWithInteger:alpha]],
             [UIColor _alignColorHexStringLength:[UIColor _hexStringWithInteger:red]],
             [UIColor _alignColorHexStringLength:[UIColor _hexStringWithInteger:green]],
             [UIColor _alignColorHexStringLength:[UIColor _hexStringWithInteger:blue]]] lowercaseString];
}

// 对于色值只有单位数的，在前面补一个0，例如“F”会补齐为“0F”
+ (NSString *)_alignColorHexStringLength:(NSString *)hexString {
    return hexString.length < 2 ? [@"0" stringByAppendingString:hexString] : hexString;
}

+ (NSString *)_hexStringWithInteger:(NSInteger)integer {
    NSString *hexString = @"";
    NSInteger remainder = 0;
    for (NSInteger i = 0; i < 9; i++) {
        remainder = integer % 16;
        integer = integer / 16;
        NSString *letter = [self _hexLetterStringWithInteger:remainder];
        hexString = [letter stringByAppendingString:hexString];
        if (integer == 0) {
            break;
        }
        
    }
    return hexString;
}

+ (NSString *)_hexLetterStringWithInteger:(NSInteger)integer {
    NSAssert(integer < 16, @"要转换的数必须是16进制里的个位数，也即小于16，但你传给我是%@", @(integer));
    
    NSString *letter = nil;
    switch (integer) {
        case 10:
            letter = @"A";
            break;
        case 11:
            letter = @"B";
            break;
        case 12:
            letter = @"C";
            break;
        case 13:
            letter = @"D";
            break;
        case 14:
            letter = @"E";
            break;
        case 15:
            letter = @"F";
            break;
        default:
            letter = [[NSString alloc]initWithFormat:@"%@", @(integer)];
            break;
    }
    return letter;
}


@end
