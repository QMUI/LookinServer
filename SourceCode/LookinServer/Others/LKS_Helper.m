//
//  LKS_Helper.m
//  LookinServer
//
//  Created by Li Kai on 2019/7/20.
//  https://lookin.work
//

#import "LKS_Helper.h"

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import "NSObject+LookinServer.h"

@implementation LKS_Helper

+ (NSString *)descriptionOfObject:(id)object {
    if (!object) {
        return @"nil";
    }
    NSString *className;
    if ([object respondsToSelector:@selector(lks_shortClassName)]) {
        className = [object lks_shortClassName];
    } else {
        className = NSStringFromClass([object class]);
    }
    
    return [NSString stringWithFormat:@"(%@ *)", className];
}

@end

#endif
