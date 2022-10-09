//
//  Color+Lookin.h
//  LookinShared
//
//  Created by 李凯 on 2022/4/2.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC

@interface NSColor (Lookin)

+ (instancetype)lookin_colorFromRGBAComponents:(NSArray<NSNumber *> *)components;

- (NSArray<NSNumber *> *)lookin_rgbaComponents;

@end

#endif

