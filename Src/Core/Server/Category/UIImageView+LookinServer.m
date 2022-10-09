//
//  UIImageView+LookinServer.m
//  LookinServer
//
//  Created by Li Kai on 2019/9/18.
//  https://lookin.work
//

#import "UIImageView+LookinServer.h"
#import "UIImage+LookinServer.h"
#import "NSObject+LookinServer.h"

@implementation UIImageView (LookinServer)

- (NSString *)lks_imageSourceName {
    return self.image.lks_imageSourceName;
}

- (NSNumber *)lks_imageViewOidIfHasImage {
    if (!self.image) {
        return nil;
    }
    unsigned long oid = [self lks_registerOid];
    return @(oid);
}

@end
