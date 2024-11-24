#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  Image+Lookin.m
//  LookinShared
//
//  Created by 李凯 on 2022/4/2.
//

#import "Image+Lookin.h"

#if TARGET_OS_IPHONE

#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
@implementation NSImage (LookinClient)

- (NSData *)lookin_data {
    return [NSBitmapImageRep representationOfImageRepsInArray:self.representations usingType:(NSBitmapImageFileTypePNG) properties:@{}];
}

@end

#endif

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
