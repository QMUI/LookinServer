//
//  LookinStaticAsyncUpdateTask.h
//  Lookin
//
//  Created by Li Kai on 2019/6/21.
//  https://lookin.work
//



#import "LookinDefines.h"

typedef NS_ENUM(NSInteger, LookinStaticAsyncUpdateTaskType) {
    LookinStaticAsyncUpdateTaskTypeNoScreenshot,
    LookinStaticAsyncUpdateTaskTypeSoloScreenshot,
    LookinStaticAsyncUpdateTaskTypeGroupScreenshot
};

/// 如果两个 Task 对象的 oid 和 taskType 均相同，则二者 equal
@interface LookinStaticAsyncUpdateTask : NSObject <NSSecureCoding>

@property(nonatomic, assign) unsigned long oid;

@property(nonatomic, assign) LookinStaticAsyncUpdateTaskType taskType;

#pragma mark - Non Coding

@property(nonatomic, assign) CGSize frameSize;

@end

@interface LookinStaticAsyncUpdateTasksPackage : NSObject <NSSecureCoding>

@property(nonatomic, copy) NSArray<LookinStaticAsyncUpdateTask *> *tasks;

@end
