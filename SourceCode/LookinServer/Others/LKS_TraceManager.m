//
//  LKS_TraceManager.m
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LKS_TraceManager.h"
#import <Objc/runtime.h>
#import "LookinIvarTrace.h"
#import "LKS_LocalInspectManager.h"

@implementation LKS_TraceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LKS_TraceManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)reload {
    // 把旧的先都清理掉
    [NSObject lks_clearAllObjectsTraces];
    
    [[[UIApplication sharedApplication].windows copy] enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _addTraceForLayersRootedByLayer:window.layer];
    }];  
}

- (void)_addTraceForLayersRootedByLayer:(CALayer *)layer {
    UIView *view = layer.lks_hostView;
    
    if ([view.superview lks_isChildrenViewOfTabBar]) {
        view.lks_isChildrenViewOfTabBar = YES;
    } else if ([view isKindOfClass:[UITabBar class]]) {
        view.lks_isChildrenViewOfTabBar = YES;
    }
    
    if (view) {
        [self _markIVarsInAllClassLevelsOfObject:view];
        if (view.lks_hostViewController) {
            [self _markIVarsInAllClassLevelsOfObject:view.lks_hostViewController];
        }
        
        [self _buildSpecialTraceForView:view];
    } else {
        [self _markIVarsInAllClassLevelsOfObject:layer];
    }
    
    [[layer.sublayers copy] enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull sublayer, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _addTraceForLayersRootedByLayer:sublayer];
    }];
}

- (void)_buildSpecialTraceForView:(UIView *)view {
    if (view.lks_hostViewController) {
        view.lks_specialTrace = [NSString stringWithFormat:@"%@.view", NSStringFromClass(view.lks_hostViewController.class)];
        
    } else if ([view isKindOfClass:[UIWindow class]]) {
        CGFloat currentWindowLevel = ((UIWindow *)view).windowLevel;
        
        if ([view isKindOfClass:[LKS_LocalInspectContainerWindow class]]) {
            view.lks_specialTrace = [NSString stringWithFormat:@"Lookin Private Window ( Level: %@ )", @(currentWindowLevel)];
        } else if (((UIWindow *)view).isKeyWindow) {
            view.lks_specialTrace = [NSString stringWithFormat:@"KeyWindow ( Level: %@ )", @(currentWindowLevel)];
        } else {
            view.lks_specialTrace = [NSString stringWithFormat:@"WindowLevel: %@", @(currentWindowLevel)];
        }
    } else if ([view isKindOfClass:[UICollectionViewCell class]]) {
        ((UICollectionViewCell *)view).contentView.lks_specialTrace = @"cell.contentView";
        
    } else if ([view isKindOfClass:[UITableViewCell class]]) {
        ((UITableViewCell *)view).backgroundView.lks_specialTrace = @"cell.backgroundView";
        ((UITableViewCell *)view).contentView.lks_specialTrace = @"cell.contentView";
        ((UITableViewCell *)view).textLabel.lks_specialTrace = @"cell.textLabel";
        ((UITableViewCell *)view).detailTextLabel.lks_specialTrace = @"cell.detailTextLabel";
        ((UITableViewCell *)view).imageView.lks_specialTrace = @"cell.imageView";
        ((UITableViewCell *)view).accessoryView.lks_specialTrace = @"cell.accessoryView";
    }

    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        tableView.backgroundView.lks_specialTrace = @"tableView.backgroundView";
        tableView.tableHeaderView.lks_specialTrace = @"tableHeaderView";
        tableView.tableFooterView.lks_specialTrace = @"tableFooterView";
        
        [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            cell.lks_specialTrace = [NSString stringWithFormat:@"{ sec:%@, row:%@ }", @(indexPath.section), @(indexPath.row)];
        }];
        
    } else if ([view isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)view;
        collectionView.backgroundView.lks_specialTrace = @"collectionView.backgroundView";
        
        if (@available(iOS 9.0, *)) {
            [[collectionView indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *headerView = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                headerView.lks_specialTrace = [NSString stringWithFormat:@"sectionHeader { sec:%@ }", @(indexPath.section)];
            }];
            [[collectionView indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionFooter] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *footerView = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
                footerView.lks_specialTrace = [NSString stringWithFormat:@"sectionFooter { sec:%@ }", @(indexPath.section)];
            }];
        }
        
        [[collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
            cell.lks_specialTrace = [NSString stringWithFormat:@"{ sec:%@, item:%@ }", @(indexPath.section), @(indexPath.item)];
        }];
        
    } else if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)view;
        headerFooterView.lks_specialTrace = @"sectionHeaderFooter";
        headerFooterView.textLabel.lks_specialTrace = @"sectionHeaderFooter.textLabel";
        headerFooterView.detailTextLabel.lks_specialTrace = @"sectionHeaderFooter.detailTextLabel";
        headerFooterView.contentView.lks_specialTrace = @"sectionHeaderFooter.contentView";
        headerFooterView.backgroundView.lks_specialTrace = @"sectionHeaderFooter.backgroundView";
    }
}

- (void)_markIVarsInAllClassLevelsOfObject:(NSObject *)object {
    [self _markIVarsOfObject:object class:object.class];
}

- (void)_markIVarsOfObject:(NSObject *)object class:(Class)targetClass {
    if (!targetClass) {
        return;
    }

    NSArray<NSString *> *prefixesToTerminateRecursion = @[@"NSObject", @"UIResponder", @"UIButton", @"UIButtonLabel"];
    BOOL hasPrefix = [prefixesToTerminateRecursion lookin_any:^BOOL(NSString *prefix) {
        return [NSStringFromClass(targetClass) hasPrefix:prefix];
    }];
    if (hasPrefix) {
        return;
    }
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(targetClass, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString *ivarType = [[NSString alloc] lookin_safeInitWithUTF8String:ivar_getTypeEncoding(ivar)];
        if (![ivarType hasPrefix:@"@"] || ivarType.length <= 3) {
            continue;
        }
        NSString *ivarClassName = [ivarType substringWithRange:NSMakeRange(2, ivarType.length - 3)];
        Class ivarClass = NSClassFromString(ivarClassName);
        if (![ivarClass isSubclassOfClass:[UIView class]] && ![ivarClass isSubclassOfClass:[CALayer class]] && ![ivarClass isSubclassOfClass:[UIViewController class]]) {
            continue;
        }
        const char * ivarNameChar = ivar_getName(ivar);
        if (!ivarNameChar) {
            continue;
        }
        NSObject *ivar_viewLayerOrController = object_getIvar(object, ivar);
        if (!ivar_viewLayerOrController) {
            continue;
        }

        LookinIvarTrace *ivarTrace = [LookinIvarTrace new];
        ivarTrace.hostClassName = NSStringFromClass(targetClass);
        ivarTrace.ivarName = [[NSString alloc] lookin_safeInitWithUTF8String:ivarNameChar];

        if ([LKS_InvalidIvarTraces() containsObject:ivarTrace]) {
            continue;
        }
        
        if (!ivar_viewLayerOrController.lks_ivarTraces) {
            ivar_viewLayerOrController.lks_ivarTraces = [NSArray array];
        }
        if (![ivar_viewLayerOrController.lks_ivarTraces containsObject:ivarTrace]) {
            ivar_viewLayerOrController.lks_ivarTraces = [ivar_viewLayerOrController.lks_ivarTraces arrayByAddingObject:ivarTrace];
        }
    }
    free(ivars);
    
    Class superClass = [targetClass superclass];
    [self _markIVarsOfObject:object class:superClass];
}

static NSSet<LookinIvarTrace *> *LKS_InvalidIvarTraces() {
    static NSSet *list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableSet *set = [NSMutableSet set];
        
        [set addObject:({
            LookinIvarTrace *trace = [LookinIvarTrace new];
            trace.hostClassName = @"UIView";
            trace.ivarName = @"_window";
            trace;
        })];
        [set addObject:({
            LookinIvarTrace *trace = [LookinIvarTrace new];
            trace.hostClassName = @"UIViewController";
            trace.ivarName = @"_view";
            trace;
        })];
        [set addObject:({
            LookinIvarTrace *trace = [LookinIvarTrace new];
            trace.hostClassName = @"UIView";
            trace.ivarName = @"_viewDelegate";
            trace;
        })];
        [set addObject:({
            LookinIvarTrace *trace = [LookinIvarTrace new];
            trace.hostClassName = @"UIViewController";
            trace.ivarName = @"_parentViewController";
            trace;
        })];
        list = set.copy;
    });
    return list;
}

@end
