//
//  UIImage+LookinServer.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LookinServer)

@property(nonatomic, copy) NSString *lks_imageSourceName;

- (NSData *)lookin_data;

@end
