#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UITextView+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/2/26.
//  https://lookin.work
//

#import <objc/runtime.h>
#import "UITextView+LookinServer.h"
#import "LKS_WindowDiscovery.h"

@implementation UITextView (LookinServer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod([self class], @selector(setInputView:));
        Method newMethod = class_getInstanceMethod([self class], @selector(lks_setInputView:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getInstanceMethod([self class], @selector(setInputAccessoryView:));
        newMethod = class_getInstanceMethod([self class], @selector(lks_setInputAccessoryView:));
        method_exchangeImplementations(oriMethod, newMethod);
    });
}

- (CGFloat)lks_fontSize {
    return self.font.pointSize;
}
- (void)setLks_fontSize:(CGFloat)lks_fontSize {
    UIFont *font = [self.font fontWithSize:lks_fontSize];
    self.font = font;
}

- (NSString *)lks_fontName {
    return self.font.fontName;
}

- (void)lks_setInputView:(UIView *)inputView {
    [self lks_setInputView:inputView];
    [[LKS_WindowDiscovery sharedInstance] addCustomWindowWithView:inputView];
}

- (void)lks_setInputAccessoryView:(UIView *)inputAccessoryView {
    [self lks_setInputAccessoryView:inputAccessoryView];
    [[LKS_WindowDiscovery sharedInstance] addCustomWindowWithView:inputAccessoryView];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
