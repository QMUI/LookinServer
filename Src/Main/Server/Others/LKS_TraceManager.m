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
#import "LookinWeakContainer.h"
#import "LKS_MultiplatformAdapter.h"
#import "NSWindow+LookinServer.h"
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

@interface LKS_TraceManager ()

@property(nonatomic, strong) NSMutableArray<LookinWeakContainer *> *searchTargets;

@end

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

- (void)addSearchTarger:(id)target {
    if (!target) {
        return;
    }
    if (!self.searchTargets) {
        self.searchTargets = [NSMutableArray array];
    }
    LookinWeakContainer *container = [LookinWeakContainer containerWithObject:target];
    [self.searchTargets addObject:container];
}

- (void)reload {
    // 把旧的先都清理掉
    [NSObject lks_clearAllObjectsTraces];
    
    [self.searchTargets enumerateObjectsUsingBlock:^(LookinWeakContainer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.object) {
            return;
        }
        [self _markIVarsInAllClassLevelsOfObject:obj.object];
    }];
    
    [[LKS_MultiplatformAdapter allWindows] enumerateObjectsUsingBlock:^(__kindof LookinWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
#if TARGET_OS_IPHONE
        [self _addTraceForLayersRootedByLayer:window.layer];
#elif TARGET_OS_OSX
        [self _addTraceForLayersRootedByLayer:window.lks_rootView.layer];
#endif
    }];
}

- (void)_addTraceForLayersRootedByLayer:(CALayer *)layer {
    LookinView *view = layer.lks_hostView;
    
#if TARGET_OS_IPHONE
    if ([view.superview lks_isChildrenViewOfTabBar]) {
        view.lks_isChildrenViewOfTabBar = YES;
    } else if ([view isKindOfClass:[UITabBar class]]) {
        view.lks_isChildrenViewOfTabBar = YES;
    }
    
#endif
    if (view) {
        [self _markIVarsInAllClassLevelsOfObject:view];
        LookinViewController* vc = [view lks_findHostViewController];
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

#if TARGET_OS_OSX
- (void)_addTraceForInterfaceObject:(id)interfaceObject {
//    LookinView *view = window.contentView;
    
    if ([interfaceObject isKindOfClass:[NSWindow class]]) {
        [self _markIVarsInAllClassLevelsOfObject:interfaceObject];
        NSWindow *window = interfaceObject;
        if (window.contentView) {
            [self _addTraceForInterfaceObject:window.contentView];
        }
    } else if ([interfaceObject isKindOfClass:[NSView class]]) {
        NSView *view = interfaceObject;
        [self _markIVarsInAllClassLevelsOfObject:view];
        LookinViewController* vc = [view lks_findHostViewController];
        if (vc) {
            [self _markIVarsInAllClassLevelsOfObject:vc];
        }
        [self _buildSpecialTraceForView:view];
        if (view.layer) {
            [self _markIVarsInAllClassLevelsOfObject:view.layer];
        }
        [[view.subviews copy] enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            [self _addTraceForInterfaceObject:subview];
        }];
    }
}
#endif

- (void)_buildSpecialTraceForView:(LookinView *)view {
    LookinViewController* vc = [view lks_findHostViewController];
    if (vc) {
        view.lks_specialTrace = [NSString stringWithFormat:@"%@.view", NSStringFromClass(vc.class)];
        
#if TARGET_OS_IPHONE
    } else if ([view isKindOfClass:[LookinWindow class]]) {
        CGFloat currentWindowLevel = ((LookinWindow *)view).windowLevel;
        
        if (((UIWindow *)view).isKeyWindow) {
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
    } else if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)view;
        headerFooterView.textLabel.lks_specialTrace = @"sectionHeaderFooter.textLabel";
        headerFooterView.detailTextLabel.lks_specialTrace = @"sectionHeaderFooter.detailTextLabel";
#elif TARGET_OS_OSX
    } else if ([view isKindOfClass:[NSTableView class]]) {
        NSTableView *tableView = (NSTableView *)view;
        tableView.headerView.lks_specialTrace = @"tableView.headerView";
        NSRect visibleRect = tableView.visibleRect;
        NSIndexSet *visibleRowIndexes = [NSIndexSet indexSetWithIndexesInRange:[tableView rowsInRect:visibleRect]];
        [visibleRowIndexes enumerateIndexesUsingBlock:^(NSUInteger row, BOOL * _Nonnull stop) {
            NSTableRowView *rowView = [tableView rowViewAtRow:row makeIfNecessary:NO];
            NSInteger level = NSNotFound;
            if ([tableView isKindOfClass:[NSOutlineView class]]) {
                NSOutlineView *outlineView = (NSOutlineView *)tableView;
                level = [outlineView levelForRow:row];
            }
            
            if (level != NSNotFound) {
                rowView.lks_specialTrace = [NSString stringWithFormat:@"{ level: %@, row: %@ }", @(level), @(row)];
            } else {
                rowView.lks_specialTrace = [NSString stringWithFormat:@"{ row: %@ }", @(row)];
            }
            
            NSInteger numberOfColumns = [tableView numberOfColumns];
            for (NSInteger column = 0; column < numberOfColumns; column++) {
                NSView *cellView = [rowView viewAtColumn:column];
                if (cellView && [cellView isKindOfClass:[NSView class]]) {
                    if (level != NSNotFound) {
                        cellView.lks_specialTrace = [NSString stringWithFormat:@"{ level: %@, row: %@, column: %@ }", @(level), @(row), @(column)];
                    } else {
                        cellView.lks_specialTrace = [NSString stringWithFormat:@"{ row: %@, column: %@ }", @(row), @(column)];
                    }
                }
            }
        }];
#endif
    } else if ([view isKindOfClass:[LookinCollectionView class]]) {
        LookinCollectionView *collectionView = (LookinCollectionView *)view;
        collectionView.backgroundView.lks_specialTrace = @"collectionView.backgroundView";
#if TARGET_OS_IPHONE
        if (@available(iOS 9.0, *)) {
            [[collectionView indexPathsForVisibleSupplementaryElementsOfKind:LookinCollectionElementKindSectionHeader] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                LookinView *headerView = [collectionView supplementaryViewForElementKind:LookinCollectionElementKindSectionHeader atIndexPath:indexPath];
                headerView.lks_specialTrace = [NSString stringWithFormat:@"sectionHeader { sec:%@ }", @(indexPath.section)];
            }];
            [[collectionView indexPathsForVisibleSupplementaryElementsOfKind:LookinCollectionElementKindSectionFooter] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                LookinView *footerView = [collectionView supplementaryViewForElementKind:LookinCollectionElementKindSectionFooter atIndexPath:indexPath];
                footerView.lks_specialTrace = [NSString stringWithFormat:@"sectionFooter { sec:%@ }", @(indexPath.section)];
            }];
        }
        [[collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
            cell.lks_specialTrace = [NSString stringWithFormat:@"{ item:%@, sec:%@ }", @(indexPath.item), @(indexPath.section)];
        }];
#elif TARGET_OS_OSX
        [[collectionView indexPathsForVisibleSupplementaryElementsOfKind:LookinCollectionElementKindSectionHeader] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, BOOL * _Nonnull stop) {
            LookinView *headerView = [collectionView supplementaryViewForElementKind:LookinCollectionElementKindSectionHeader atIndexPath:indexPath];
            headerView.lks_specialTrace = [NSString stringWithFormat:@"sectionHeader { sec:%@ }", @(indexPath.section)];
        }];
        [[collectionView indexPathsForVisibleSupplementaryElementsOfKind:LookinCollectionElementKindSectionFooter] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, BOOL * _Nonnull stop) {
            LookinView *footerView = [collectionView supplementaryViewForElementKind:LookinCollectionElementKindSectionFooter atIndexPath:indexPath];
            footerView.lks_specialTrace = [NSString stringWithFormat:@"sectionFooter { sec:%@ }", @(indexPath.section)];
        }];
        [[collectionView visibleItems] enumerateObjectsUsingBlock:^(NSCollectionViewItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [collectionView indexPathForItem:item];
            item.lks_specialTrace = [NSString stringWithFormat:@"{ item:%@, sec:%@ }", @(indexPath.item), @(indexPath.section)];
        }];
#endif
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

    NSArray<NSString *> *prefixesToTerminateRecursion = @[@"NSObject", @"UIResponder", @"UIButton", @"UIButtonLabel", @"NSResponder"];
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
        if (![ivarClass isSubclassOfClass:[LookinView class]]
            && ![ivarClass isSubclassOfClass:[CALayer class]]
            && ![ivarClass isSubclassOfClass:[LookinViewController class]]
            && ![ivarClass isSubclassOfClass:[LookinGestureRecognizer class]]) {
            continue;
        }
        const char * ivarNameChar = ivar_getName(ivar);
        if (!ivarNameChar) {
            continue;
        }
        // 这个 ivarObject 可能的类型：UIView, CALayer, UIViewController, UIGestureRecognizer
        NSObject *ivarObject = object_getIvar(hostObject, ivar);
        if (!ivarObject || ![ivarObject isKindOfClass:[NSObject class]]) {
            continue;
        }

        LookinIvarTrace *ivarTrace = [LookinIvarTrace new];
        ivarTrace.hostObject = hostObject;
        ivarTrace.hostClassName = [self makeDisplayClassNameWithSuper:targetClass childClass:hostObject.class];
        ivarTrace.ivarName = [[NSString alloc] lookin_safeInitWithUTF8String:ivarNameChar];
        
        if (hostObject == ivarObject) {
            ivarTrace.relation = LookinIvarTraceRelationValue_Self;
        } else if ([hostObject isKindOfClass:[LookinView class]]) {
            CALayer *ivarLayer = nil;
            if ([ivarObject isKindOfClass:[CALayer class]]) {
                ivarLayer = (CALayer *)ivarObject;
            } else if ([ivarObject isKindOfClass:[LookinView class]]) {
                ivarLayer = ((LookinView *)ivarObject).layer;
            }
            if (ivarLayer && (ivarLayer.superlayer == ((LookinView *)hostObject).layer)) {
                ivarTrace.relation = @"superview";
            }
        }

        if ([LKS_InvalidIvarTraces() containsObject:ivarTrace]) {
            continue;
        }
        
        if (![ivarObject respondsToSelector:@selector(lks_ivarTraces)] || ![ivarObject respondsToSelector:@selector(setLks_ivarTraces:)]) {
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

// 比如 superClass 可能是 UIView，而 childClass 可能是 UIButton
- (NSString *)makeDisplayClassNameWithSuper:(Class)superClass childClass:(Class)childClass {
    NSString *superName = NSStringFromClass(superClass);
    if (!childClass) {
        return superName;
    }
    NSString *childName = NSStringFromClass(childClass);
    if ([childName isEqualToString:superName]) {
        return superName;
    }
    return [NSString stringWithFormat:@"%@ : %@", childName, superName];
}

static NSSet<LookinIvarTrace *> *LKS_InvalidIvarTraces(void) {
    static NSSet *list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableSet *set = [NSMutableSet set];
        
        [set addObject:({
            LookinIvarTrace *trace = [LookinIvarTrace new];
            trace.hostClassName = LookinViewString;
            trace.ivarName = @"_window";
            trace;
        })];
        [set addObject:({
            LookinIvarTrace *trace = [LookinIvarTrace new];
            trace.hostClassName = LookinViewControllerString;
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
            trace.hostClassName = LookinViewControllerString;
            trace.ivarName = @"_parentViewController";
            trace;
        })];
        list = set.copy;
    });
    return list;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
