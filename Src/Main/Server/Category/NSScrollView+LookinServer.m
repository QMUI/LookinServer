//
//  NSScrollView+LookinServer.m
//  LookinServer
//
//  Created by JH on 2024/11/7.
//

#import "NSScrollView+LookinServer.h"
#if TARGET_OS_OSX

@implementation NSScrollView (LookinServer)

- (void)setLks_contentOffset:(CGPoint)lks_contentOffset {
    [self.contentView scrollToPoint:lks_contentOffset];
}

- (CGPoint)lks_contentOffset {
    return self.contentView.bounds.origin;
}

- (void)setLks_contentSize:(CGSize)lks_contentSize {
    [self.documentView setFrameSize:lks_contentSize];
}

- (CGSize)lks_contentSize {
    return self.documentView.frame.size;
}

@end
#endif
