#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_HierarchyDetailsHandler.m
//  LookinServer
//
//  Created by Li Kai on 2019/6/20.
//  https://lookin.work
//

#import "LKS_HierarchyDetailsHandler.h"
#import "LookinDisplayItemDetail.h"
#import "LKS_AttrGroupsMaker.h"
#import "LookinStaticAsyncUpdateTask.h"
#import "LKS_ConnectionManager.h"
#import "LookinServerDefines.h"
#import "LKS_CustomAttrGroupsMaker.h"
#import "LKS_HierarchyDisplayItemsMaker.h"

@interface LKS_HierarchyDetailsHandler ()

@property(nonatomic, strong) NSMutableArray<LookinStaticAsyncUpdateTasksPackage *> *taskPackages;
/// 标识哪些 oid 已经拉取过 attrGroups 了
@property(nonatomic, strong) NSMutableSet<NSNumber *> *attrGroupsSyncedOids;

@property(nonatomic, copy) LKS_HierarchyDetailsHandler_ProgressBlock progressBlock;
@property(nonatomic, copy) LKS_HierarchyDetailsHandler_FinishBlock finishBlock;

@end

@implementation LKS_HierarchyDetailsHandler

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleConnectionDidEnd:) name:LKS_ConnectionDidEndNotificationName object:nil];
        
        self.attrGroupsSyncedOids = [NSMutableSet set];
    }
    return self;
}

- (void)startWithPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages block:(LKS_HierarchyDetailsHandler_ProgressBlock)progressBlock finishedBlock:(LKS_HierarchyDetailsHandler_FinishBlock)finishBlock {
    if (!progressBlock || !finishBlock) {
        NSAssert(NO, @"");
        return;
    }
    if (!packages.count) {
        finishBlock();
        return;
    }
    self.taskPackages = [packages mutableCopy];
    self.progressBlock = progressBlock;
    self.finishBlock = finishBlock;
    
    [UIView lks_rebuildGlobalInvolvedRawConstraints];
    
    [self _dequeueAndHandlePackage];
}

- (void)cancel {
    [self.taskPackages removeAllObjects];
}

- (void)_dequeueAndHandlePackage {
    dispatch_async(dispatch_get_main_queue(), ^{
        LookinStaticAsyncUpdateTasksPackage *package = self.taskPackages.firstObject;
        if (!package) {
            self.finishBlock();
            return;
        }
        //        NSLog(@"LookinServer - will handle tasks, count: %@", @(tasks.count));
        NSArray<LookinDisplayItemDetail *> *details = [package.tasks lookin_map:^id(NSUInteger idx, LookinStaticAsyncUpdateTask *task) {
            LookinDisplayItemDetail *itemDetail = [LookinDisplayItemDetail new];
            itemDetail.displayItemOid = task.oid;
            
            id object = [NSObject lks_objectWithOid:task.oid];
            if (!object || ![object isKindOfClass:[CALayer class]]) {
                itemDetail.failureCode = -1;
                return itemDetail;
            }
            
            CALayer *layer = object;

            if (task.taskType == LookinStaticAsyncUpdateTaskTypeSoloScreenshot) {
                UIImage *image = [layer lks_soloScreenshotWithLowQuality:NO];
                itemDetail.soloScreenshot = image;
            } else if (task.taskType == LookinStaticAsyncUpdateTaskTypeGroupScreenshot) {
                UIImage *image = [layer lks_groupScreenshotWithLowQuality:NO];
                itemDetail.groupScreenshot = image;
            }
            
            BOOL shouldMakeAttr = [self queryIfShouldMakeAttrsFromTask:task];
            if (shouldMakeAttr) {
                itemDetail.attributesGroupList = [LKS_AttrGroupsMaker attrGroupsForLayer:layer];
                
                NSString *version = task.clientReadableVersion;
                if (version.length > 0 && [version lookin_numbericOSVersion] >= 10004) {
                    LKS_CustomAttrGroupsMaker *maker = [[LKS_CustomAttrGroupsMaker alloc] initWithLayer:layer];
                    [maker execute];
                    itemDetail.customAttrGroupList = [maker getGroups];
                    itemDetail.customDisplayTitle = [maker getCustomDisplayTitle];
                    itemDetail.danceUISource = [maker getDanceUISource];
                }
                [self.attrGroupsSyncedOids addObject:@(task.oid)];
            }
            
            if (task.needBasisVisualInfo) {
                itemDetail.frameValue = [NSValue valueWithCGRect:layer.frame];
                itemDetail.boundsValue = [NSValue valueWithCGRect:layer.bounds];
                itemDetail.hiddenValue = [NSNumber numberWithBool:layer.isHidden];
                itemDetail.alphaValue = @(layer.opacity);
            }
            
            if (task.needSubitems) {
                itemDetail.subitems = [LKS_HierarchyDisplayItemsMaker subitemsOfLayer:layer];
            }
            
            return itemDetail;
        }];
        self.progressBlock(details);
        
        [self.taskPackages removeObjectAtIndex:0];
        [self _dequeueAndHandlePackage];
    });
}

- (BOOL)queryIfShouldMakeAttrsFromTask:(LookinStaticAsyncUpdateTask *)task {
    switch (task.attrRequest) {
        case LookinDetailUpdateTaskAttrRequest_Automatic: {
            BOOL alreadyMadeBefore = [self.attrGroupsSyncedOids containsObject:@(task.oid)];
            return !alreadyMadeBefore;
        }
        case LookinDetailUpdateTaskAttrRequest_Need:
            return YES;
        case LookinDetailUpdateTaskAttrRequest_NotNeed:
            return NO;
    }
    NSAssert(NO, @"");
    return YES;
}

- (void)_handleConnectionDidEnd:(id)obj {
    [self cancel];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
