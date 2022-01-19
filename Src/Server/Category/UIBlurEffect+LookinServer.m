//
//  UIBlurEffect+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/10/8.
//  https://lookin.work
//

#import "UIBlurEffect+LookinServer.h"
#import "NSObject+Lookin.h"
#import <objc/runtime.h>

@implementation UIBlurEffect (LookinServer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getClassMethod([UIBlurEffect class], @selector(effectWithStyle:));
        Method newMethod = class_getClassMethod([UIBlurEffect class], @selector(lks_effectWithStyle:));
        method_exchangeImplementations(oriMethod, newMethod);
    });
}

+ (UIBlurEffect *)lks_effectWithStyle:(UIBlurEffectStyle)style {
    id effect = [self lks_effectWithStyle:style];
    if ([effect respondsToSelector:@selector(setLks_effectStyleNumber:)]) {
        [effect setLks_effectStyleNumber:@(style)];
    }
    return effect;
}

- (void)setLks_effectStyleNumber:(NSNumber *)lks_effectStyleNumber {
    [self lookin_bindObject:lks_effectStyleNumber forKey:@"lks_effectStyleNumber"];
}

- (NSNumber *)lks_effectStyleNumber {
    return [self lookin_getBindObjectForKey:@"lks_effectStyleNumber"];
}

@end
