//
//  UIVisualEffectView+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/10/8.
//  https://lookin.work
//

#import "UIVisualEffectView+LookinServer.h"
#import "UIBlurEffect+LookinServer.h"

@implementation UIVisualEffectView (LookinServer)

- (void)setLks_blurEffectStyleNumber:(NSNumber *)lks_blurEffectStyleNumber {
    UIBlurEffectStyle style = [lks_blurEffectStyleNumber integerValue];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    self.effect = effect;
}

- (NSNumber *)lks_blurEffectStyleNumber {
    UIVisualEffect *effect = self.effect;
    if (![effect isKindOfClass:[UIBlurEffect class]]) {
        return nil;
    }
    UIBlurEffect *blurEffect = (UIBlurEffect *)effect;
    return blurEffect.lks_effectStyleNumber;
}

@end
