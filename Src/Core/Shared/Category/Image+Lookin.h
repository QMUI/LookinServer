#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  Image+Lookin.h
//  LookinShared
//
//  Created by 李凯 on 2022/4/2.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#elif TARGET_OS_MAC

@interface NSImage (LookinClient)

- (NSData *)lookin_data;

@end

#endif


#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
