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

@property(nonatomic, copy) NSString *lks_imageSourceName;

- (NSData *)lookin_data;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
