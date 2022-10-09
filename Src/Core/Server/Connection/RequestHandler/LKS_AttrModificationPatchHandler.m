//
//  LKS_AttrModificationPatchHandler.m
//  LookinServer
//
//  Created by Li Kai on 2019/6/12.
//  https://lookin.work
//

#import "LKS_AttrModificationPatchHandler.h"
#import "LookinDisplayItemDetail.h"
#import "LookinServerDefines.h"

@implementation LKS_AttrModificationPatchHandler

+ (void)handleLayerOids:(NSArray<NSNumber *> *)oids lowImageQuality:(BOOL)lowImageQuality block:(void (^)(LookinDisplayItemDetail *detail, NSUInteger tasksTotalCount, NSError *error))block {
    if (!block) {
        NSAssert(NO, @"");
        return;
    }
    if (![oids isKindOfClass:[NSArray class]]) {
        block(nil, 1, LookinErr_Inner);
        return;
    }
    
    [oids enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unsigned long oid = [obj unsignedLongValue];
        LookinDisplayItemDetail *detail = [LookinDisplayItemDetail new];
        detail.displayItemOid = oid;
        
        CALayer *layer = (CALayer *)[NSObject lks_objectWithOid:oid];
        if (![layer isKindOfClass:[CALayer class]]) {
            block(nil, idx + 1, LookinErr_ObjNotFound);
            *stop = YES;
            return;
        }
        
        if (idx == 0) {
            detail.soloScreenshot = [layer lks_soloScreenshotWithLowQuality:lowImageQuality];
            detail.groupScreenshot = [layer lks_groupScreenshotWithLowQuality:lowImageQuality];
        } else {
            detail.groupScreenshot = [layer lks_groupScreenshotWithLowQuality:lowImageQuality];
        }
        block(detail, oids.count, nil);
    }];
}

@end
