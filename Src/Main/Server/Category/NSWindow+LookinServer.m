//
//  NSWindow+LookinServer.m
//  LookinServer
//
//  Created by JH on 11/5/24.
//

#import "NSWindow+LookinServer.h"

#if TARGET_OS_OSX

@implementation NSWindow (LookinServer)

- (NSView *)lks_rootView {
    return self.contentView.superview;
}

- (NSImage *)lks_snapshotImage {
    CGImageRef cgImage = CGWindowListCreateImage(CGRectZero, kCGWindowListOptionIncludingWindow, (int)self.windowNumber, kCGWindowImageBoundsIgnoreFraming);
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:self.frame.size];
    CGImageRelease(cgImage);
    return image;
}

- (CGRect)lks_bounds {
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    return frame;
}

@end

#endif
