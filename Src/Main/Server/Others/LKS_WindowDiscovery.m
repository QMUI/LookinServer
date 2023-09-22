//
//  LKS_WindowDiscovery.m
//  LookinServer
//
//  Created by andysheng on 2023/1/6.
//

#import "LKS_WindowDiscovery.h"
#import "LKS_WeakObjContainer.h"

@interface LKS_WindowDiscovery ()

@property (nonatomic, strong) NSArray<LKS_WeakObjContainer<UIWindow *> *> *customWindows;
@property (nonatomic, strong) NSArray<LKS_WeakObjContainer<UIView *> *> *customViews;

@end

@implementation LKS_WindowDiscovery

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_WindowDiscovery *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

- (void)addCustomWindow:(UIWindow *)window {
    if (!window) {
        return;
    }
    @synchronized (self) {
        NSMutableArray<LKS_WeakObjContainer<UIWindow *> *> *mContainers = self.customWindows ? self.customWindows.mutableCopy : [NSMutableArray array];
        [mContainers enumerateObjectsWithOptions:NSEnumerationReverse
                                      usingBlock:^(LKS_WeakObjContainer * _Nonnull container, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!container.weakObj || container.weakObj == window) {
                [mContainers removeObject:container];
            }
        }];
        [mContainers addObject:[LKS_WeakObjContainer containerWithObj:window]];
        self.customWindows = mContainers.copy;
    }
}

- (void)addCustomWindowWithView:(UIView *)view {
    if (!view) {
        return;
    }
    @synchronized (self) {
        NSMutableArray<LKS_WeakObjContainer<UIView *> *> *mContainers = self.customViews ? self.customViews.mutableCopy : NSMutableArray.array;
        [mContainers enumerateObjectsWithOptions:NSEnumerationReverse
                                      usingBlock:^(LKS_WeakObjContainer * _Nonnull container, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!container.weakObj || container.weakObj == view) {
                [mContainers removeObject:container];
            }
        }];
        [mContainers addObject:[LKS_WeakObjContainer containerWithObj:view]];
        self.customViews = mContainers.copy;
    }
}

- (NSArray<UIWindow *> *)windows {
    NSMutableArray<UIWindow *> *retWindows = [[UIApplication sharedApplication].windows mutableCopy];
    NSSet<UIWindow *> *windowSet = [NSSet setWithArray:retWindows];

    NSMutableArray<UIWindow *> *candidateCustomWindows = [NSMutableArray array];
    [self.customWindows enumerateObjectsUsingBlock:^(LKS_WeakObjContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIWindow *window = (UIWindow *)obj.weakObj;
        if (window) {
            [candidateCustomWindows addObject:window];
        }
    }];
    [self.customViews enumerateObjectsUsingBlock:^(LKS_WeakObjContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIWindow *window = ((UIView *)obj.weakObj).window;
        if (window) {
            [candidateCustomWindows addObject:window];
        }
    }];
    [candidateCustomWindows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![windowSet containsObject:window]) {
            [retWindows addObject:window];
        }
    }];
    return retWindows;
}

@end
