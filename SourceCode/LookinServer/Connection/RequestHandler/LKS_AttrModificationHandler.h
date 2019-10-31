//
//  LKS_AttrModificationHandler.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/12.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <Foundation/Foundation.h>

@class LookinAttributeModification, LookinDisplayItemDetail, LookinStaticAsyncUpdateTask;

@interface LKS_AttrModificationHandler : NSObject

+ (void)handleModification:(LookinAttributeModification *)modification completion:(void (^)(LookinDisplayItemDetail *data, NSError *error))completion;

+ (void)handlePatchWithTasks:(NSArray<LookinStaticAsyncUpdateTask *> *)tasks block:(void (^)(LookinDisplayItemDetail *data))block;

@end

#endif
