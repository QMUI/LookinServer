#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LookinCustomDisplayItemInfo.h
//  LookinServer
//
//  Created by likai.123 on 2023/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LookinCustomDisplayItemInfo : NSObject <NSSecureCoding, NSCopying>

/// 当 isUserCustom 为 NO 时，该属性必定为 nil
/// 当 isUserCustom 为 YES 时，该属性可能有值（CGRect）也可能是 nil
@property(nonatomic, strong) NSValue *frameInWindow;

@end

NS_ASSUME_NONNULL_END

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
