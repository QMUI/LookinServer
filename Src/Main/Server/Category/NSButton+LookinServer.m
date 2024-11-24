//
//  NSButton+LookinServer.m
//  LookinServer
//
//  Created by JH on 2024/11/7.
//

#import "NSButton+LookinServer.h"

#if TARGET_OS_OSX
@implementation NSButton (LookinServer)
- (NSButtonType)lks_buttonType {
    return [[self valueForKeyPath:@"cell._buttonType"] unsignedIntegerValue];
}
@end
#endif
