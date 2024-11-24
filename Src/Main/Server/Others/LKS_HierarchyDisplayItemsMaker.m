#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LKS_HierarchyDisplayItemsMaker.m
//  LookinServer
//
//  Created by Li Kai on 2019/2/19.
//  https://lookin.work
//

#import "LKS_HierarchyDisplayItemsMaker.h"
#import "LookinDisplayItem.h"
#import "LKS_TraceManager.h"
#import "LKS_AttrGroupsMaker.h"
#import "LKS_EventHandlerMaker.h"
#import "LookinServerDefines.h"
#import "UIColor+LookinServer.h"
#import "LKSConfigManager.h"
#import "LKS_CustomAttrGroupsMaker.h"
#import "LKS_CustomDisplayItemsMaker.h"
#import "LKS_CustomAttrSetterManager.h"
#import "LKS_MultiplatformAdapter.h"
#import "NSValue+Lookin.h"
#import "LookinObject+LookinServer.h"
#import "NSWindow+LookinServer.h"
@implementation LKS_HierarchyDisplayItemsMaker

+ (NSArray<LookinDisplayItem *> *)itemsWithScreenshots:(BOOL)hasScreenshots attrList:(BOOL)hasAttrList lowImageQuality:(BOOL)lowQuality readCustomInfo:(BOOL)readCustomInfo saveCustomSetter:(BOOL)saveCustomSetter {
    
    [[LKS_TraceManager sharedInstance] reload];
    
    NSArray<LookinWindow *> *windows = [LKS_MultiplatformAdapter allWindows];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:windows.count];
    [windows enumerateObjectsUsingBlock:^(__kindof LookinWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
#if TARGET_OS_IPHONE
        LookinDisplayItem *item = [self _displayItemWithLayer:window.layer screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality readCustomInfo:readCustomInfo saveCustomSetter:saveCustomSetter];
#elif TARGET_OS_OSX
        CALayer *rootLayer = window.lks_rootView.layer;
        LookinDisplayItem *item = [LookinDisplayItem new];
        item.windowObject = [LookinObject instanceWithObject:window];
        item.frame = window.lks_bounds;
        item.bounds = window.lks_bounds;
        item.backgroundColor = window.backgroundColor;
        item.shouldCaptureImage = YES;
        item.alpha = window.alphaValue;
        item.groupScreenshot = [rootLayer lks_groupScreenshotWithLowQuality:lowQuality];
        item.soloScreenshot = [rootLayer lks_soloScreenshotWithLowQuality:lowQuality];
        item.screenshotEncodeType = LookinDisplayItemImageEncodeTypeNSData;
        if (rootLayer) {
            item.subitems = @[[self _displayItemWithLayer:rootLayer screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality readCustomInfo:readCustomInfo saveCustomSetter:saveCustomSetter]];
        } else {
            item.subitems = @[[self _displayItemWithView:window.lks_rootView screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality readCustomInfo:readCustomInfo saveCustomSetter:saveCustomSetter]];
        }
#endif
        item.representedAsKeyWindow = window.isKeyWindow;
        if (item) {
            [resultArray addObject:item];
        }
    }];
    
    return [resultArray copy];
}

+ (LookinDisplayItem *)_displayItemWithLayer:(CALayer *)layer screenshots:(BOOL)hasScreenshots attrList:(BOOL)hasAttrList lowImageQuality:(BOOL)lowQuality readCustomInfo:(BOOL)readCustomInfo saveCustomSetter:(BOOL)saveCustomSetter {
    if (!layer) {
        return nil;
    }
    
    LookinDisplayItem *item = [LookinDisplayItem new];
    CGRect layerFrame = layer.frame;
    LookinView *hostView = layer.lks_hostView;
    if (hostView && hostView.superview) {
        layerFrame = [hostView.superview convertRect:layerFrame toView:nil];
    }
    if ([self validateFrame:layerFrame]) {
        item.frame = layer.frame;
    } else {
        NSLog(@"LookinServer - The layer frame(%@) seems really weird. Lookin will ignore it to avoid potential render error in Lookin.", NSStringFromCGRect(layer.frame));
        item.frame = CGRectZero;
    }
    item.bounds = layer.bounds;
    if (hasScreenshots) {
        item.soloScreenshot = [layer lks_soloScreenshotWithLowQuality:lowQuality];
        item.groupScreenshot = [layer lks_groupScreenshotWithLowQuality:lowQuality];
        item.screenshotEncodeType = LookinDisplayItemImageEncodeTypeNSData;
    }
    
    if (hasAttrList) {
        item.attributesGroupList = [LKS_AttrGroupsMaker attrGroupsForLayer:layer];
        LKS_CustomAttrGroupsMaker *maker = [[LKS_CustomAttrGroupsMaker alloc] initWithLayer:layer];
        [maker execute];
        item.customAttrGroupList = [maker getGroups];
        item.customDisplayTitle = [maker getCustomDisplayTitle];
        item.danceuiSource = [maker getDanceUISource];
    }
    
    item.isHidden = layer.isHidden;
    item.alpha = layer.opacity;
    item.layerObject = [LookinObject instanceWithObject:layer];
    item.shouldCaptureImage = [LKSConfigManager shouldCaptureScreenshotOfLayer:layer];
    
    LookinView *view = layer.lks_hostView;
    if (view) {
#if TARGET_OS_OSX
        item.flipped = view.isFlipped;
#endif
        item.viewObject = [LookinObject instanceWithObject:view];
        item.eventHandlers = [LKS_EventHandlerMaker makeForView:view];
        item.backgroundColor = [view valueForKeyPath:@"backgroundColor"];
        
        LookinViewController* vc = [view lks_findHostViewController];
        if (vc) {
            item.hostViewControllerObject = [LookinObject instanceWithObject:vc];
        }
    } else {
#if TARGET_OS_OSX
        item.flipped = layer.isGeometryFlipped;
#endif
        item.backgroundColor = [LookinColor lks_colorWithCGColor:layer.backgroundColor];
    }
    
    if (layer.sublayers.count) {
        NSArray<CALayer *> *sublayers = [layer.sublayers copy];
        NSMutableArray<LookinDisplayItem *> *allSubitems = [NSMutableArray arrayWithCapacity:sublayers.count];
        [sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull sublayer, NSUInteger idx, BOOL * _Nonnull stop) {
            LookinDisplayItem *sublayer_item = [self _displayItemWithLayer:sublayer screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality readCustomInfo:readCustomInfo saveCustomSetter:saveCustomSetter];
            if (sublayer_item) {
                [allSubitems addObject:sublayer_item];
            }
        }];
        item.subitems = [allSubitems copy];
    }
    if (readCustomInfo) {
        NSArray<LookinDisplayItem *> *customSubitems = [[[LKS_CustomDisplayItemsMaker alloc] initWithLayer:layer saveAttrSetter:saveCustomSetter] make];
        if (customSubitems.count > 0) {
            if (item.subitems) {
                item.subitems = [item.subitems arrayByAddingObjectsFromArray:customSubitems];
            } else {
                item.subitems = customSubitems;
            }
        }
    }
    
    return item;
}

+ (NSArray<LookinDisplayItem *> *)subitemsOfLayer:(CALayer *)layer {
    if (!layer || layer.sublayers.count == 0) {
        return @[];
    }
    [[LKS_TraceManager sharedInstance] reload];
    
    NSMutableArray<LookinDisplayItem *> *resultSubitems = [NSMutableArray array];
    
    NSArray<CALayer *> *sublayers = [layer.sublayers copy];
    [sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull sublayer, NSUInteger idx, BOOL * _Nonnull stop) {
        LookinDisplayItem *sublayer_item = [self _displayItemWithLayer:sublayer screenshots:NO attrList:NO lowImageQuality:NO readCustomInfo:YES saveCustomSetter:YES];
        if (sublayer_item) {
            [resultSubitems addObject:sublayer_item];
        }
    }];
    
    NSArray<LookinDisplayItem *> *customSubitems = [[[LKS_CustomDisplayItemsMaker alloc] initWithLayer:layer saveAttrSetter:YES] make];
    if (customSubitems.count > 0) {
        [resultSubitems addObjectsFromArray:customSubitems];
    }
    
    return resultSubitems;
}

#if TARGET_OS_OSX
+ (LookinDisplayItem *)_displayItemWithView:(NSView *)view screenshots:(BOOL)hasScreenshots attrList:(BOOL)hasAttrList lowImageQuality:(BOOL)lowQuality readCustomInfo:(BOOL)readCustomInfo saveCustomSetter:(BOOL)saveCustomSetter {
    if (!view) {
        return nil;
    }
    
    LookinDisplayItem *item = [LookinDisplayItem new];
    CGRect viewFrame = view.frame;
    
    if (view.superview) {
        viewFrame = [view.superview convertRect:viewFrame toView:nil];
    }
    if ([self validateFrame:viewFrame]) {
        item.frame = view.frame;
    } else {
        NSLog(@"LookinServer - The layer frame(%@) seems really weird. Lookin will ignore it to avoid potential render error in Lookin.", NSStringFromCGRect(view.frame));
        item.frame = CGRectZero;
    }
    item.bounds = view.bounds;
    item.flipped = view.isFlipped;
    if (hasScreenshots) {
        item.soloScreenshot = [view lks_soloScreenshotWithLowQuality:lowQuality];
        item.groupScreenshot = [view lks_groupScreenshotWithLowQuality:lowQuality];
        item.screenshotEncodeType = LookinDisplayItemImageEncodeTypeNSData;
    }
    
    if (hasAttrList) {
        item.attributesGroupList = [LKS_AttrGroupsMaker attrGroupsForView:view];
        LKS_CustomAttrGroupsMaker *maker = [[LKS_CustomAttrGroupsMaker alloc] initWithView:view];
        [maker execute];
        item.customAttrGroupList = [maker getGroups];
        item.customDisplayTitle = [maker getCustomDisplayTitle];
        item.danceuiSource = [maker getDanceUISource];
    }
    
    item.isHidden = view.isHidden;
    item.alpha = view.alphaValue;
    item.viewObject = [LookinObject instanceWithObject:view];
    if (view.layer) {
        item.layerObject = [LookinObject instanceWithObject:view.layer];
    }
    item.shouldCaptureImage = [LKSConfigManager shouldCaptureScreenshotOfView:view];
    
    item.viewObject = [LookinObject instanceWithObject:view];
    item.eventHandlers = [LKS_EventHandlerMaker makeForView:view];
    item.backgroundColor = [view valueForKeyPath:@"backgroundColor"];
    
    LookinViewController* vc = [view lks_findHostViewController];
    if (vc) {
        item.hostViewControllerObject = [LookinObject instanceWithObject:vc];
    }
    
    
    if (view.subviews.count) {
        NSArray<NSView *> *subviews = [view.subviews copy];
        NSMutableArray<LookinDisplayItem *> *allSubitems = [NSMutableArray arrayWithCapacity:subviews.count];
        [subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!subview.layer) {
                LookinDisplayItem *sub_item = [self _displayItemWithView:subview screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality readCustomInfo:readCustomInfo saveCustomSetter:saveCustomSetter];
                if (sub_item) {
                    [allSubitems addObject:sub_item];
                }
            } else {
                LookinDisplayItem *sub_item = [self _displayItemWithLayer:subview.layer screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality readCustomInfo:readCustomInfo saveCustomSetter:saveCustomSetter];
                if (sub_item) {
                    [allSubitems addObject:sub_item];
                }
            }
        }];
        item.subitems = [allSubitems copy];
    }
    if (readCustomInfo) {
        NSArray<LookinDisplayItem *> *customSubitems = [[[LKS_CustomDisplayItemsMaker alloc] initWithView:view saveAttrSetter:saveCustomSetter] make];
        if (customSubitems.count > 0) {
            if (item.subitems) {
                item.subitems = [item.subitems arrayByAddingObjectsFromArray:customSubitems];
            } else {
                item.subitems = customSubitems;
            }
        }
    }
    
    return item;
}

+ (NSArray<LookinDisplayItem *> *)subitemsOfView:(NSView *)view {
    if (!view || view.subviews.count == 0) {
        return @[];
    }
    [[LKS_TraceManager sharedInstance] reload];
    
    NSMutableArray<LookinDisplayItem *> *resultSubitems = [NSMutableArray array];
    
    NSArray<NSView *> *subviews = [view.subviews copy];
    [subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!subview.layer) {
            LookinDisplayItem *sub_item = [self _displayItemWithView:subview screenshots:NO attrList:NO lowImageQuality:NO readCustomInfo:YES saveCustomSetter:YES];
            if (sub_item) {
                [resultSubitems addObject:sub_item];
            }
        } else {
            LookinDisplayItem *sub_item = [self _displayItemWithLayer:subview.layer screenshots:NO attrList:NO lowImageQuality:NO readCustomInfo:YES saveCustomSetter:YES];
            if (sub_item) {
                [resultSubitems addObject:sub_item];
            }
        }
    }];
    
    NSArray<LookinDisplayItem *> *customSubitems = [[[LKS_CustomDisplayItemsMaker alloc] initWithView:view saveAttrSetter:YES] make];
    if (customSubitems.count > 0) {
        [resultSubitems addObjectsFromArray:customSubitems];
    }
    
    return resultSubitems;
}
#endif


+ (BOOL)validateFrame:(CGRect)frame {
    return !CGRectIsNull(frame) && !CGRectIsInfinite(frame) && ![self cgRectIsNaN:frame] && ![self cgRectIsInf:frame] && ![self cgRectIsUnreasonable:frame];
}

+ (BOOL)cgRectIsNaN:(CGRect)rect {
    return isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height);
}

+ (BOOL)cgRectIsInf:(CGRect)rect {
    return isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height);
}

+ (BOOL)cgRectIsUnreasonable:(CGRect)rect {
    return ABS(rect.origin.x) > 100000 || ABS(rect.origin.y) > 100000 || rect.size.width < 0 || rect.size.height < 0 || rect.size.width > 100000 || rect.size.height > 100000;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
