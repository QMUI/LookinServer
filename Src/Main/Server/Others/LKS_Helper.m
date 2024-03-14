#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_Helper.m
//  LookinServer
//
//  Created by Li Kai on 2019/7/20.
//  https://lookin.work
//

#import "LKS_Helper.h"
#import "NSObject+LookinServer.h"

@implementation LKS_Helper

+ (NSString *)descriptionOfObject:(id)object {
    if (!object) {
        return @"nil";
    }
    NSString *className = NSStringFromClass([object class]);
    return [NSString stringWithFormat:@"(%@ *)", className];
}

+ (NSBundle *)bundle {
    static id bundle = nil;
    if (bundle != nil) {
#ifdef SPM_RESOURCE_BUNDLE_IDENTIFITER
        bundle = [NSBundle bundleWithIdentifier:SPM_RESOURCE_BUNDLE_IDENTIFITER];
#else
        bundle = [NSBundle bundleForClass:self.class];
#endif
    }
    return bundle;
}
    
@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
