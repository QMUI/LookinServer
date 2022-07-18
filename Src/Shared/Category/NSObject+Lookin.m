//
//  NSObject+Lookin.m
//  Lookin
//
//  Created by Li Kai on 2018/12/22.
//  https://lookin.work
//

#import "NSObject+Lookin.h"
#import <objc/runtime.h>
#import "TargetConditionals.h"
#import "LookinWeakContainer.h"

@implementation NSObject (Lookin)

#pragma mark - Data Bind

static char kAssociatedObjectKey_LookinAllBindObjects;
- (NSMutableDictionary<id, id> *)lookin_allBindObjects {
    NSMutableDictionary<id, id> *dict = objc_getAssociatedObject(self, &kAssociatedObjectKey_LookinAllBindObjects);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &kAssociatedObjectKey_LookinAllBindObjects, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)lookin_bindObject:(id)object forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return;
    }
    @synchronized (self) {
        if (object) {
            [[self lookin_allBindObjects] setObject:object forKey:key];
        } else {
            [[self lookin_allBindObjects] removeObjectForKey:key];
        }
    }
}

- (id)lookin_getBindObjectForKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return nil;
    }
    @synchronized (self) {
        id storedObj = [[self lookin_allBindObjects] objectForKey:key];
        if ([storedObj isKindOfClass:[LookinWeakContainer class]]) {
            storedObj = [(LookinWeakContainer *)storedObj object];
        }
        return storedObj;
    }
}

- (void)lookin_bindObjectWeakly:(id)object forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return;
    }
    if (object) {
        LookinWeakContainer *container = [[LookinWeakContainer alloc] init];
        container.object = object;
        [self lookin_bindObject:container forKey:key];
    } else {
        [self lookin_bindObject:nil forKey:key];
    }
}

- (void)lookin_bindDouble:(double)doubleValue forKey:(NSString *)key {
    [self lookin_bindObject:@(doubleValue) forKey:key];
}

- (double)lookin_getBindDoubleForKey:(NSString *)key {
    id object = [self lookin_getBindObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        double doubleValue = [(NSNumber *)object doubleValue];
        return doubleValue;
        
    } else {
        return 0.0;
    }
}

- (void)lookin_bindBOOL:(BOOL)boolValue forKey:(NSString *)key {
    [self lookin_bindObject:@(boolValue) forKey:key];
}

- (BOOL)lookin_getBindBOOLForKey:(NSString *)key {
    id object = [self lookin_getBindObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        BOOL boolValue = [(NSNumber *)object boolValue];
        return boolValue;
        
    } else {
        return NO;
    }
}

- (void)lookin_bindLong:(long)longValue forKey:(NSString *)key {
    [self lookin_bindObject:@(longValue) forKey:key];
}

- (long)lookin_getBindLongForKey:(NSString *)key {
    id object = [self lookin_getBindObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        long longValue = [(NSNumber *)object longValue];
        return longValue;
        
    } else {
        return 0;
    }
}

- (void)lookin_bindPoint:(CGPoint)pointValue forKey:(NSString *)key {
#if TARGET_OS_IPHONE
    [self lookin_bindObject:[NSValue valueWithCGPoint:pointValue] forKey:key];
#elif TARGET_OS_MAC
    NSPoint nsPoint = NSMakePoint(pointValue.x, pointValue.y);
    [self lookin_bindObject:[NSValue valueWithPoint:nsPoint] forKey:key];
#endif
}

- (CGPoint)lookin_getBindPointForKey:(NSString *)key {
    id object = [self lookin_getBindObjectForKey:key];
    if ([object isKindOfClass:[NSValue class]]) {
#if TARGET_OS_IPHONE
        CGPoint pointValue = [(NSValue *)object CGPointValue];
#elif TARGET_OS_MAC
        NSPoint nsPointValue = [(NSValue *)object pointValue];
        CGPoint pointValue = CGPointMake(nsPointValue.x, nsPointValue.y);
#endif
        return pointValue;
    } else {
        return CGPointZero;
    }
}

- (void)lookin_clearBindForKey:(NSString *)key {
    [self lookin_bindObject:nil forKey:key];
}

@end

@implementation NSObject (Lookin_Coding)

- (id)lookin_encodedObjectWithType:(LookinCodingValueType)type {
    if (type == LookinCodingValueTypeColor) {
        if ([self isKindOfClass:[LookinColor class]]) {
            CGFloat r, g, b, a;
#if TARGET_OS_IPHONE
            CGFloat white;
            if ([(UIColor *)self getRed:&r green:&g blue:&b alpha:&a]) {
                // valid
            } else if ([(UIColor *)self getWhite:&white alpha:&a]) {
                r = white;
                g = white;
                b = white;
            } else {
                NSAssert(NO, @"");
                r = 0;
                g = 0;
                b = 0;
                a = 0;
            }
#elif TARGET_OS_MAC
            NSColor *color = [((NSColor *)self) colorUsingColorSpace:NSColorSpace.sRGBColorSpace];
            [color getRed:&r green:&g blue:&b alpha:&a];
#endif
            NSArray<NSNumber *> *rgba = @[@(r), @(g), @(b), @(a)];
            return rgba;
            
        } else {
            NSAssert(NO, @"");
            return nil;
        }
        
    } else if (type == LookinCodingValueTypeImage) {
#if TARGET_OS_IPHONE
        if ([self isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)self;
            return UIImagePNGRepresentation(image);
            
        } else {
            NSAssert(NO, @"");
            return nil;
        }
#elif TARGET_OS_MAC
        if ([self isKindOfClass:[NSImage class]]) {
            NSImage *image = (NSImage *)self;
            return [image TIFFRepresentation];
            
        } else {
            NSAssert(NO, @"");
            return nil;
        }
#endif
        
    } else {
        return self;
    }
}

- (id)lookin_decodedObjectWithType:(LookinCodingValueType)type {
    if (type == LookinCodingValueTypeColor) {
        if ([self isKindOfClass:[NSArray class]]) {
            NSArray<NSNumber *> *rgba = (NSArray *)self;
            CGFloat r = [rgba[0] doubleValue];
            CGFloat g = [rgba[1] doubleValue];
            CGFloat b = [rgba[2] doubleValue];
            CGFloat a = [rgba[3] doubleValue];
            LookinColor *color = [LookinColor colorWithRed:r green:g blue:b alpha:a];
            return color;
            
        } else {
            NSAssert(NO, @"");
            return nil;
        }
        
    } else if (type == LookinCodingValueTypeImage) {
        if ([self isKindOfClass:[NSData class]]) {
            LookinImage *image = [[LookinImage alloc] initWithData:(NSData *)self];
            return image;
        } else {
            NSAssert(NO, @"");
            return nil;
        }
            
    } else {
        return self;
    }
}

@end
