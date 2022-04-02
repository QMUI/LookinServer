//
//  Image+Lookin.m
//  LookinShared
//
//  Created by 李凯 on 2022/4/2.
//

#import "Image+Lookin.h"

#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC

@implementation NSImage (LookinClient)

- (NSData *)lookin_data {
    return [self TIFFRepresentation];
}

@end

#endif
