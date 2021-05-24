//
//  UIImage+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/14.
//  https://lookin.work
//

#import "UIImage+LookinServer.h"
#import "Objc/runtime.h"
#import "LookinServerDefines.h"

@implementation UIImage (LookinServer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getClassMethod([self class], @selector(imageNamed:));
        Method newMethod = class_getClassMethod([self class], @selector(lks_imageNamed:));
        method_exchangeImplementations(oriMethod, newMethod);
        
        oriMethod = class_getClassMethod([self class], @selector(imageWithContentsOfFile:));
        newMethod = class_getClassMethod([self class], @selector(lks_imageWithContentsOfFile:));
        method_exchangeImplementations(oriMethod, newMethod);
    });
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

- (NSData *)lookin_data {
    return UIImagePNGRepresentation(self);
}

@end
