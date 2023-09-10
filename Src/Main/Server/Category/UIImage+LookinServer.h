#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIImage+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/14.
//  https://lookin.work
//

#import <UIKit/UIKit.h>

@interface UIImage (LookinServer)

/// 该方法的实现需要 Hook，因此若定义了 LOOKIN_SERVER_DISABLE_HOOK 宏，则属性会返回 nil
@property(nonatomic, copy) NSString *lks_imageSourceName;

- (NSData *)lookin_data;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
