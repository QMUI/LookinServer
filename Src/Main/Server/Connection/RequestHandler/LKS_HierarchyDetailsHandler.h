#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_HierarchyDetailsHandler.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/20.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@class LookinDisplayItemDetail, LookinStaticAsyncUpdateTasksPackage;

typedef void (^LKS_HierarchyDetailsHandler_ProgressBlock)(NSArray<LookinDisplayItemDetail *> *details);
typedef void (^LKS_HierarchyDetailsHandler_FinishBlock)(void);

@interface LKS_HierarchyDetailsHandler : NSObject

/// packages 会按照 idx 从小到大的顺序被执行
/// 全部任务完成时，finishBlock 会被调用
/// 如果调用了 cancel，则 finishBlock 不会被执行
- (void)startWithPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages block:(LKS_HierarchyDetailsHandler_ProgressBlock)progressBlock finishedBlock:(LKS_HierarchyDetailsHandler_FinishBlock)finishBlock;

/// 取消所有任务
- (void)cancel;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
