#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIVisualEffectView+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/10/8.
//  https://lookin.work
//

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@interface UIVisualEffectView (LookinServer)

- (void)setLks_blurEffectStyleNumber:(NSNumber *)lks_blurEffectStyleNumber;

- (NSNumber *)lks_blurEffectStyleNumber;

@end
#endif

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
