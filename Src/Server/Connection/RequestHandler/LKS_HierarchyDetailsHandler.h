//
//  LKS_HierarchyDetailsHandler.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/20.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@class LookinDisplayItemDetail, LookinStaticAsyncUpdateTasksPackage;

typedef void (^LKS_HierarchyDetailsHandler_Block)(NSArray<LookinDisplayItemDetail *> *details, NSError *error);

@interface LKS_HierarchyDetailsHandler : NSObject

+ (instancetype)sharedInstance;

/// packages 会按照 idx 从大到小的顺序被执行
- (void)startWithPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages block:(LKS_HierarchyDetailsHandler_Block)block;

- (void)bringForwardWithPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages;

/// 取消所有任务
- (void)cancel;

@end
