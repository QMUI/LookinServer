#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIImage+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/14.
//  https://lookin.work
//

#import <objc/runtime.h>
#import "UIImage+LookinServer.h"
#import "LookinServerDefines.h"

@implementation UIImage (LookinServer)

- (NSData *)lookin_data {
    return UIImagePNGRepresentation(self);
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
