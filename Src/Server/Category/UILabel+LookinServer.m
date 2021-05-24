//
//  UILabel+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/2/26.
//  https://lookin.work
//

#import "UILabel+LookinServer.h"

@implementation UILabel (LookinServer)

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

@end
