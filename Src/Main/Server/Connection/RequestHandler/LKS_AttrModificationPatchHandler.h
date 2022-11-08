#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_AttrModificationPatchHandler.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/12.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@class LookinDisplayItemDetail;

@interface LKS_AttrModificationPatchHandler : NSObject

/**
 @param oids 数组内 idx 较小的应该为 displayItems 里的 subItem，idx 较大的应该为 superItem
 @param lowImageQuality 是否采用低图像质量
 @param block 该 block 会被多次调用，其中 tasksTotalCount 是总的调用次数（即可被用来作为 TotalResponseCount）
 */
+ (void)handleLayerOids:(NSArray<NSNumber *> *)oids lowImageQuality:(BOOL)lowImageQuality block:(void (^)(LookinDisplayItemDetail *detail, NSUInteger tasksTotalCount, NSError *error))block;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
