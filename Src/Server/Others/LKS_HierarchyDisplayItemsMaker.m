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
    item.frame = layer.frame;
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
        item.backgroundColor = [UIColor colorWithCGColor:layer.backgroundColor];
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

@end
