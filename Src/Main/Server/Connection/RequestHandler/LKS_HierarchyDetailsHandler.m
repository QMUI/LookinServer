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

@interface LKS_HierarchyDetailsHandler ()

@property(nonatomic, strong) NSMutableArray<LookinStaticAsyncUpdateTasksPackage *> *taskPackages;
@property(nonatomic, strong) NSMutableSet<LookinStaticAsyncUpdateTask *> *finishedTasks;
/// 标识哪些 oid 已经拉取过 attrGroups 了
@property(nonatomic, strong) NSMutableSet<NSNumber *> *attrGroupsSyncedOids;

@property(nonatomic, copy) LKS_HierarchyDetailsHandler_Block handlerBlock;

@property(nonatomic, assign) NSUInteger bbb;

@end

@implementation LKS_HierarchyDetailsHandler

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_HierarchyDetailsHandler *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleConnectionDidEnd:) name:LKS_ConnectionDidEndNotificationName object:nil];
        
        self.attrGroupsSyncedOids = [NSMutableSet set];
        self.finishedTasks = [NSMutableSet set];
    }
    return self;
}

- (void)startWithPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages block:(LKS_HierarchyDetailsHandler_Block)block {
    if (!block) {
        NSAssert(NO, @"");
        return;
    }
    if (!packages.count) {
        block(nil, LookinErr_Inner);
        return;
    }
    [self.finishedTasks removeAllObjects];
    [self.attrGroupsSyncedOids removeAllObjects];
    self.taskPackages = [packages mutableCopy];
    self.handlerBlock = block;
    
    [UIView lks_rebuildGlobalInvolvedRawConstraints];
    
    [self _dequeueAndHandlePackage];
}

- (void)bringForwardWithPackages:(NSArray<LookinStaticAsyncUpdateTasksPackage *> *)packages {
    NSLog(@"LookinServer - willBringForward");
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, packages.count)];
    [self.taskPackages insertObjects:packages atIndexes:indexSet];
}

- (void)cancel {
    [self.taskPackages removeAllObjects];
}

- (void)_dequeueAndHandlePackage {
    dispatch_async(dispatch_get_main_queue(), ^{
        LookinStaticAsyncUpdateTasksPackage *package = self.taskPackages.firstObject;
        if (!package) {
            return;
        }
        //        NSLog(@"LookinServer - will handle tasks, count: %@", @(tasks.count));
        NSArray<LookinDisplayItemDetail *> *details = [package.tasks lookin_map:^id(NSUInteger idx, LookinStaticAsyncUpdateTask *task) {
            if ([self.finishedTasks containsObject:task]) {
                return nil;
            }
            [self.finishedTasks addObject:task];
            
            LookinDisplayItemDetail *itemDetail = [LookinDisplayItemDetail new];
            itemDetail.displayItemOid = task.oid;
            
            id object = [NSObject lks_objectWithOid:task.oid];
            if (!object || ![object isKindOfClass:[CALayer class]]) {
                return itemDetail;
            }
            
            CALayer *layer = object;
            
            if (![self.attrGroupsSyncedOids containsObject:@(task.oid)]) {
                itemDetail.attributesGroupList = [LKS_AttrGroupsMaker attrGroupsForLayer:layer];
                
                NSString *version = task.clientReadableVersion;
                if (version.length > 0 && [version lookin_numbericOSVersion] >= 10004) {
                    itemDetail.customAttrGroupList = [[[LKS_CustomAttrGroupsMaker alloc] initWithLayer:layer] make];
                }
                [self.attrGroupsSyncedOids addObject:@(task.oid)];
            }
            if (task.taskType == LookinStaticAsyncUpdateTaskTypeSoloScreenshot) {
                UIImage *image = [layer lks_soloScreenshotWithLowQuality:NO];
                itemDetail.soloScreenshot = image;
            } else if (task.taskType == LookinStaticAsyncUpdateTaskTypeGroupScreenshot) {
                UIImage *image = [layer lks_groupScreenshotWithLowQuality:NO];
                itemDetail.groupScreenshot = image;
            }
            return itemDetail;
        }];
        self.handlerBlock(details, nil);
        
        [self.taskPackages removeObjectAtIndex:0];
        [self _dequeueAndHandlePackage];
    });
}

- (void)_handleConnectionDidEnd:(id)obj {
    [self cancel];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
