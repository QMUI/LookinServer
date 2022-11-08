#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  UIGestureRecognizer+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/8/14.
//  https://lookin.work
//

#import <UIKit/UIKit.h>

@class LookinTwoTuple;

@interface UIGestureRecognizer (LookinServer)

/// tuple.first => LookinWeakContainer(包裹着 target)，tuple.second => action(方法名字符串)
@property(nonatomic, strong) NSMutableArray<LookinTwoTuple *> *lks_targetActions;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
