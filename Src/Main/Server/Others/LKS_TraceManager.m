#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_TraceManager.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/5.
//  https://lookin.work
//

#import "LKS_TraceManager.h"
#import <objc/runtime.h>
#import "LookinIvarTrace.h"
#import "LookinServerDefines.h"
#import "LKS_LocalInspectManager.h"

#ifdef LOOKIN_SERVER_SWIFT_ENABLED

#if __has_include(<LookinServer/LookinServer-Swift.h>)
    #import <LookinServer/LookinServer-Swift.h>
    #define LOOKIN_SERVER_SWIFT_ENABLED_SUCCESSFULLY
#elif __has_include("LookinServer-Swift.h")
    #import "LookinServer-Swift.h"
    #define LOOKIN_SERVER_SWIFT_ENABLED_SUCCESSFULLY
#endif

#endif

#ifdef SPM_LOOKIN_SERVER_ENABLED
@import LookinServerSwift;
#define LOOKIN_SERVER_SWIFT_ENABLED_SUCCESSFULLY
#endif

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
        UIViewController* vc = [view lks_findHostViewController];
        if (vc) {
            [self _markIVarsInAllClassLevelsOfObject:vc];
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
    UIViewController* vc = [view lks_findHostViewController];
    if (vc) {
        view.lks_specialTrace = [NSString stringWithFormat:@"%@.view", NSStringFromClass(vc.class)];
        
    } else if ([view isKindOfClass:[UIWindow class]]) {
        CGFloat currentWindowLevel = ((UIWindow *)view).windowLevel;
        
        if ([view isKindOfClass:[LKS_LocalInspectContainerWindow class]]) {
            view.lks_specialTrace = [NSString stringWithFormat:@"Lookin Private Window ( Level: %@ )", @(currentWindowLevel)];
        } else if (((UIWindow *)view).isKeyWindow) {
            view.lks_specialTrace = [NSString stringWithFormat:@"KeyWindow ( Level: %@ )", @(currentWindowLevel)];
        } else {
            view.lks_specialTrace = [NSString stringWithFormat:@"WindowLevel: %@", @(currentWindowLevel)];
        }
    } else if ([view isKindOfClass:[UITableViewCell class]]) {
        ((UITableViewCell *)view).backgroundView.lks_specialTrace = @"cell.backgroundView";
        ((UITableViewCell *)view).accessoryView.lks_specialTrace = @"cell.accessoryView";
    
    } else if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        
        NSMutableArray<NSNumber *> *relatedSectionIdx = [NSMutableArray array];
        [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            cell.lks_specialTrace = [NSString stringWithFormat:@"{ sec:%@, row:%@ }", @(indexPath.section), @(indexPath.row)];
            
            if (![relatedSectionIdx containsObject:@(indexPath.section)]) {
                [relatedSectionIdx addObject:@(indexPath.section)];
            }
        }];
        
        [relatedSectionIdx enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger secIdx = [obj unsignedIntegerValue];
            UIView *secHeaderView = [tableView headerViewForSection:secIdx];
            secHeaderView.lks_specialTrace = [NSString stringWithFormat:@"sectionHeader { sec: %@ }", @(secIdx)];
            
            UIView *secFooterView = [tableView footerViewForSection:secIdx];
            secFooterView.lks_specialTrace = [NSString stringWithFormat:@"sectionFooter { sec: %@ }", @(secIdx)];
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
            cell.lks_specialTrace = [NSString stringWithFormat:@"{ item:%@, sec:%@ }", @(indexPath.item), @(indexPath.section)];
        }];
        
    } else if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)view;
        headerFooterView.textLabel.lks_specialTrace = @"sectionHeaderFooter.textLabel";
        headerFooterView.detailTextLabel.lks_specialTrace = @"sectionHeaderFooter.detailTextLabel";
    }
}

- (void)_markIVarsInAllClassLevelsOfObject:(NSObject *)object {
    [self _markIVarsOfObject:object class:object.class];
#ifdef LOOKIN_SERVER_SWIFT_ENABLED_SUCCESSFULLY
    [LKS_SwiftTraceManager swiftMarkIVarsOfObject:object];
#endif
}

- (void)_markIVarsOfObject:(NSObject *)hostObject class:(Class)targetClass {
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
        if (![ivarClass isSubclassOfClass:[UIView class]]
            && ![ivarClass isSubclassOfClass:[CALayer class]]
            && ![ivarClass isSubclassOfClass:[UIViewController class]]
            && ![ivarClass isSubclassOfClass:[UIGestureRecognizer class]]) {
            continue;
        }
        const char * ivarNameChar = ivar_getName(ivar);
        if (!ivarNameChar) {
            continue;
        }
        // 这个 ivarObject 可能的类型：UIView, CALayer, UIViewController, UIGestureRecognizer
        NSObject *ivarObject = object_getIvar(hostObject, ivar);
        if (!ivarObject) {
            continue;
        }

        LookinIvarTrace *ivarTrace = [LookinIvarTrace new];
        ivarTrace.hostObject = hostObject;
        ivarTrace.hostClassName = NSStringFromClass(targetClass);
        ivarTrace.ivarName = [[NSString alloc] lookin_safeInitWithUTF8String:ivarNameChar];
        
        if (hostObject == ivarObject) {
            ivarTrace.relation = LookinIvarTraceRelationValue_Self;
        } else if ([hostObject isKindOfClass:[UIView class]]) {
            CALayer *ivarLayer = nil;
            if ([ivarObject isKindOfClass:[CALayer class]]) {
                ivarLayer = (CALayer *)ivarObject;
            } else if ([ivarObject isKindOfClass:[UIView class]]) {
                ivarLayer = ((UIView *)ivarObject).layer;
            }
            if (ivarLayer && (ivarLayer.superlayer == ((UIView *)hostObject).layer)) {
                ivarTrace.relation = @"superview";
            }
        }

        if ([LKS_InvalidIvarTraces() containsObject:ivarTrace]) {
            continue;
        }
        
        if (!ivarObject.lks_ivarTraces) {
            ivarObject.lks_ivarTraces = [NSArray array];
        }
        if (![ivarObject.lks_ivarTraces containsObject:ivarTrace]) {
            ivarObject.lks_ivarTraces = [ivarObject.lks_ivarTraces arrayByAddingObject:ivarTrace];
        }
    }
    free(ivars);
    
    Class superClass = [targetClass superclass];
    [self _markIVarsOfObject:hostObject class:superClass];
}

static NSSet<LookinIvarTrace *> *LKS_InvalidIvarTraces(void) {
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

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
