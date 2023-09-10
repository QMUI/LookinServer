#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIImageView+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/9/18.
//  https://lookin.work
//

#import <UIKit/UIKit.h>

@interface UIImageView (LookinServer)

- (NSString *)lks_imageSourceName;
- (NSNumber *)lks_imageViewOidIfHasImage;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
