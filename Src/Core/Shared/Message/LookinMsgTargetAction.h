#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinMsgTargetAction.h
//  Lookin
//
//  Created by Li Kai on 2019/8/19.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

/// target 和 relatedObject 相等，action 名字相同则认为 equal
@interface LookinMsgTargetAction : NSObject

@property(nonatomic, weak) id target;

@property(nonatomic, assign) SEL action;

@property(nonatomic, weak) id relatedObject;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
