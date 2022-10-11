#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinWeakContainer.h
//  Lookin
//
//  Created by Li Kai on 2019/8/14.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

@interface LookinWeakContainer : NSObject

+ (instancetype)containerWithObject:(id)object;

@property (nonatomic, weak) id object;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
