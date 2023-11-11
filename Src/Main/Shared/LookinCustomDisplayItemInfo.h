#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LookinCustomDisplayItemInfo.h
//  LookinServer
//
//  Created by likai.123 on 2023/11/1.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LookinCustomDisplayItemInfo : NSObject <NSSecureCoding, NSCopying>

/// 该属性可能有值（CGRect）也可能是 nil（nil 时则表示无图像）
@property(nonatomic, strong) NSValue *frameInWindow;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
