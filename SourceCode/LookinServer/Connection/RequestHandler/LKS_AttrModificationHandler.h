//
//  LKS_AttrModificationHandler.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinAttributeModification, LookinDisplayItemDetail, LookinStaticAsyncUpdateTask;

@interface LKS_AttrModificationHandler : NSObject

+ (void)handleModification:(LookinAttributeModification *)modification completion:(void (^)(LookinDisplayItemDetail *data, NSError *error))completion;

+ (void)handlePatchWithTasks:(NSArray<LookinStaticAsyncUpdateTask *> *)tasks block:(void (^)(LookinDisplayItemDetail *data))block;

@end
