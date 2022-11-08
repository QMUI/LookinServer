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

@implementation LKS_HierarchyDisplayItemsMaker

+ (NSArray<LookinDisplayItem *> *)itemsWithScreenshots:(BOOL)hasScreenshots attrList:(BOOL)hasAttrList lowImageQuality:(BOOL)lowQuality includedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows {
    [[LKS_TraceManager sharedInstance] reload];
    
    NSArray<UIWindow *> *windows = [[UIApplication sharedApplication].windows copy];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:windows.count];
    [windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (includedWindows.count) {
            if (![includedWindows containsObject:window]) {
                return;
            }
        } else if ([excludedWindows containsObject:window]) {
            return;
        }
        LookinDisplayItem *item = [self _displayItemWithLayer:window.layer screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality];
        item.representedAsKeyWindow = window.isKeyWindow;
        if (item) {
            [resultArray addObject:item];
        }
    }];
    
    return [resultArray copy];
}

+ (LookinDisplayItem *)_displayItemWithLayer:(CALayer *)layer screenshots:(BOOL)hasScreenshots attrList:(BOOL)hasAttrList lowImageQuality:(BOOL)lowQuality {
    if (!layer || layer.lks_avoidCapturing) {
        return nil;
    }
    
    LookinDisplayItem *item = [LookinDisplayItem new];
    if ([self validateFrame:layer.frame]) {
        item.frame = layer.frame;
    } else {
        NSLog(@"LookinServer - 该 layer 的 frame(%@) 不太寻常，可能导致 Lookin 客户端中图像渲染错误，因此这里暂时将其视为 CGRectZero", NSStringFromCGRect(layer.frame));
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
    }
    
    item.isHidden = layer.isHidden;
    item.alpha = layer.opacity;
    item.layerObject = [LookinObject instanceWithObject:layer];
    
    if (layer.lks_hostView) {
        UIView *view = layer.lks_hostView;
        item.viewObject = [LookinObject instanceWithObject:view];
        item.eventHandlers = [LKS_EventHandlerMaker makeForView:view];
        item.backgroundColor = view.backgroundColor;
        
        if (view.lks_hostViewController) {
            item.hostViewControllerObject = [LookinObject instanceWithObject:view.lks_hostViewController];
        }
    } else {
        item.backgroundColor = [UIColor lks_colorWithCGColor:layer.backgroundColor];
    }
    
    if (layer.sublayers.count) {
        NSArray<CALayer *> *sublayers = [layer.sublayers copy];
        NSMutableArray<LookinDisplayItem *> *array = [NSMutableArray arrayWithCapacity:sublayers.count];
        [sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull sublayer, NSUInteger idx, BOOL * _Nonnull stop) {
            LookinDisplayItem *sublayer_item = [self _displayItemWithLayer:sublayer screenshots:hasScreenshots attrList:hasAttrList lowImageQuality:lowQuality];
            if (sublayer_item) {
                [array addObject:sublayer_item];
            }
        }];
        item.subitems = [array copy];
    }
    
    return item;
}

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
