//
//  UIColor+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/5.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <UIKit/UIKit.h>

@interface UIColor (LookinServer)

- (NSArray<NSNumber *> *)lks_rgbaComponents;
+ (instancetype)lks_colorFromRGBAComponents:(NSArray<NSNumber *> *)components;

- (NSString *)lks_rgbaString;
- (NSString *)lks_hexString;

@end

#endif
