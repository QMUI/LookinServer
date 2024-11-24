//
//  NSValue+Lookin.m
//  LookinServer
//
//  Created by JH on 2024/11/5.
//

#import "NSValue+Lookin.h"

NSString *NSStringFromInsets(LookinInsets insets) {
    return [NSString stringWithFormat:@"{%.*g, %.*g, %.*g, %.*g}", 17, insets.top, 17, insets.left, 17, insets.bottom, 17, insets.right];
}
#if TARGET_OS_OSX
NSString *NSStringFromCGAffineTransform(CGAffineTransform transform) {
    return [NSString stringWithFormat:@"[%.*g, %.*g, %.*g, %.*g, %.*g, %.*g]", 17, transform.a, 17, transform.b, 17, transform.c, 17, transform.d, 17, transform.tx, 17, transform.ty];
}
NSString *NSStringFromCGVector(CGVector vector) {
    return [NSString stringWithFormat:@"{%.*g, %.*g}", 17, vector.dx, 17, vector.dy];
}
NSString *NSStringFromCGRect(CGRect rect) {
    return NSStringFromRect(rect);
}
NSString *NSStringFromCGPoint(CGPoint point) {
    return NSStringFromPoint(point);
}
NSString *NSStringFromCGSize(CGSize size) {
    return NSStringFromSize(size);
}
NSString *NSStringFromDirectionalEdgeInsets(NSDirectionalEdgeInsets insets) {
    return [NSString stringWithFormat:@"{%.*g, %.*g, %.*g, %.*g}", 17, insets.top, 17, insets.leading, 17, insets.bottom, 17, insets.trailing];
}
#endif
@implementation NSValue (Lookin)
#if TARGET_OS_OSX
+ (NSValue *)valueWithCGVector:(CGVector)vector {
    return [self valueWithBytes:&vector objCType:@encode(CGVector)];
}

+ (NSValue *)valueWithCGRect:(CGRect)rect {
    return [self valueWithRect:rect];
}

+ (NSValue *)valueWithCGSize:(CGSize)size {
    return [self valueWithSize:size];
}

+ (NSValue *)valueWithCGPoint:(CGPoint)point {
    return [self valueWithPoint:point];
}

+ (NSValue *)valueWithCGAffineTransform:(CGAffineTransform)transform {
    return [self valueWithBytes:&transform objCType:@encode(CGAffineTransform)];
}

- (CGAffineTransform)CGAffineTransformValue {
    CGAffineTransform transform;
    [self getValue:&transform];
    return transform;
}

- (CGVector)CGVectorValue {
    CGVector vector;
    [self getValue:&vector];
    return vector;
}

- (CGRect)CGRectValue {
    return [self rectValue];
}

- (CGPoint)CGPointValue {
    return [self pointValue];
}

- (CGSize)CGSizeValue {
    return [self sizeValue];
}
#endif
+ (NSValue *)valueWithInsets:(LookinInsets)insets {
#if TARGET_OS_IPHONE
    return [self valueWithUIEdgeInsets:insets];
#endif
    
#if TARGET_OS_OSX
    return [self valueWithEdgeInsets:insets];
#endif
}

- (LookinInsets)InsetsValue {
#if TARGET_OS_IPHONE
    return self.UIEdgeInsetsValue;
#endif
    
#if TARGET_OS_OSX
    return [self edgeInsetsValue];
#endif
}

@end
