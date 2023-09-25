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

#ifdef LOOKIN_SERVER_DISABLE_HOOK

- (void)setLks_imageSourceName:(NSString *)lks_imageSourceName {
}

- (NSString *)lks_imageSourceName {
    return nil;
}

#else

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getClassMethod([self class], @selector(imageNamed:));
        Method newMethod = class_getClassMethod([self class], @selector(lks_imageNamed:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getClassMethod([self class], @selector(imageWithContentsOfFile:));
        newMethod = class_getClassMethod([self class], @selector(lks_imageWithContentsOfFile:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getClassMethod([self class], @selector(imageNamed:inBundle:compatibleWithTraitCollection:));
        newMethod = class_getClassMethod([self class], @selector(lks_imageNamed:inBundle:compatibleWithTraitCollection:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        if (@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)) {
            oriMethod = class_getClassMethod([self class], @selector(imageNamed:inBundle:withConfiguration:));
            newMethod = class_getClassMethod([self class], @selector(lks_imageNamed:inBundle:withConfiguration:));
            method_exchangeImplementations(oriMethod, newMethod);
        }
    });
}

+ (nullable UIImage *)lks_imageNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle withConfiguration:(nullable UIImageConfiguration *)configuration API_AVAILABLE(ios(13.0),tvos(13.0),watchos(6.0))
{
    UIImage *image = [self lks_imageNamed:name inBundle:bundle withConfiguration:configuration];
    image.lks_imageSourceName = name;
    return image;
}

+ (nullable UIImage *)lks_imageNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection API_AVAILABLE(ios(8.0))
{
    UIImage *image = [self lks_imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
    image.lks_imageSourceName = name;
    return image;
}

+ (UIImage *)lks_imageNamed:(NSString *)name {
    UIImage *image = [self lks_imageNamed:name];
    image.lks_imageSourceName = name;
    return image;
}

+ (UIImage *)lks_imageWithContentsOfFile:(NSString *)path {
    UIImage *image = [self lks_imageWithContentsOfFile:path];
    
    NSString *fileName = [[path componentsSeparatedByString:@"/"].lastObject componentsSeparatedByString:@"."].firstObject;
    image.lks_imageSourceName = fileName;
    return image;
}

- (void)setLks_imageSourceName:(NSString *)lks_imageSourceName {
    [self lookin_bindObject:lks_imageSourceName.copy forKey:@"lks_imageSourceName"];
}

- (NSString *)lks_imageSourceName {
    return [self lookin_getBindObjectForKey:@"lks_imageSourceName"];
}

#endif /* LOOKIN_SERVER_DISABLE_HOOK */

- (NSData *)lookin_data {
    return UIImagePNGRepresentation(self);
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
