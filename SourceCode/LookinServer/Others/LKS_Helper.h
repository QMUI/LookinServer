//
//  LKS_Helper.h
//  LookinServer
//
//  Created by Li Kai on 2019/7/20.
//  https://lookin.work
//

#import "LookinDefines.h"

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <Foundation/Foundation.h>

#define LKS_Localized(stringKey) NSLocalizedStringFromTableInBundle(stringKey, nil, [NSBundle bundleForClass:self.class], nil)

@interface LKS_Helper : NSObject

/// 如果 object 为 nil 则返回字符串 “nil”，否则返回字符串格式类似于 (UIView *)
+ (NSString *)descriptionOfObject:(id)object;

@end

#endif
