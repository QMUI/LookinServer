#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UITextField+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/2/26.
//  https://lookin.work
//

#import <UIKit/UIKit.h>

@interface UITextField (LookinServer)

@property(nonatomic, assign) CGFloat lks_fontSize;

- (NSString *)lks_fontName;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
