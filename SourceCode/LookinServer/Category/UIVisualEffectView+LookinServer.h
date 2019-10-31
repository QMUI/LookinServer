//
//  UIVisualEffectView+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/10/8.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <UIKit/UIKit.h>

@interface UIVisualEffectView (LookinServer)

- (void)setLks_blurEffectStyleNumber:(NSNumber *)lks_blurEffectStyleNumber;

- (NSNumber *)lks_blurEffectStyleNumber;

@end

#endif
