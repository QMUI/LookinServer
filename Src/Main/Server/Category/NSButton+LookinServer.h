//
//  NSButton+LookinServer.h
//  LookinServer
//
//  Created by JH on 2024/11/7.
//

#import "TargetConditionals.h"

#if TARGET_OS_OSX

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSButton (LookinServer)
@property (nonatomic, readonly) NSButtonType lks_buttonType;
@end

NS_ASSUME_NONNULL_END

#endif
