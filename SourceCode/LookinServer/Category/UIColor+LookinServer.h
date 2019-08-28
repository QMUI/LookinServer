//
//  UIColor+LookinServer.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LookinServer)

- (NSArray<NSNumber *> *)lks_rgbaComponents;
+ (instancetype)lks_colorFromRGBAComponents:(NSArray<NSNumber *> *)components;

- (NSString *)lks_rgbaString;
- (NSString *)lks_hexString;

@end
