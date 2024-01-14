#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LookinDisplayItem.m
//  qmuidemo
//
//  Created by Li Kai on 2018/11/15.
//  Copyright © 2018 QMUI Team. All rights reserved.
//

#import "LookinDisplayItem.h"
#import "LookinAttributesGroup.h"
#import "LookinAttributesSection.h"
#import "LookinAttribute.h"
#import "LookinEventHandler.h"
#import "LookinIvarTrace.h"
#import "Color+Lookin.h"
#import "NSArray+Lookin.h"
#import "NSObject+Lookin.h"
#import "LookinDashboardBlueprint.h"

#if TARGET_OS_IPHONE
#import "UIColor+LookinServer.h"
#import "UIImage+LookinServer.h"
#elif TARGET_OS_MAC
#endif

@interface LookinDisplayItem ()

@property(nonatomic, assign, readwrite) CGRect frameToRoot;
@property(nonatomic, assign, readwrite) BOOL inNoPreviewHierarchy;
@property(nonatomic, assign) NSInteger indentLevel;
@property(nonatomic, assign, readwrite) BOOL isExpandable;
@property(nonatomic, assign, readwrite) BOOL inHiddenHierarchy;
@property(nonatomic, assign, readwrite) BOOL displayingInHierarchy;

@end

@implementation LookinDisplayItem

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    LookinDisplayItem *newDisplayItem = [[LookinDisplayItem allocWithZone:zone] init];
    newDisplayItem.subitems = [self.subitems lookin_map:^id(NSUInteger idx, LookinDisplayItem *value) {
        return value.copy;
    }];
    newDisplayItem.customInfo = self.customInfo.copy;
    newDisplayItem.isHidden = self.isHidden;
    newDisplayItem.alpha = self.alpha;
    newDisplayItem.frame = self.frame;
    newDisplayItem.bounds = self.bounds;
    newDisplayItem.soloScreenshot = self.soloScreenshot;
    newDisplayItem.groupScreenshot = self.groupScreenshot;
    newDisplayItem.viewObject = self.viewObject.copy;
    newDisplayItem.layerObject = self.layerObject.copy;
    newDisplayItem.hostViewControllerObject = self.hostViewControllerObject.copy;
    newDisplayItem.attributesGroupList = [self.attributesGroupList lookin_map:^id(NSUInteger idx, LookinAttributesGroup *value) {
        return value.copy;
    }];
    newDisplayItem.customAttrGroupList = [self.customAttrGroupList lookin_map:^id(NSUInteger idx, LookinAttributesGroup *value) {
        return value.copy;
    }];
    newDisplayItem.eventHandlers = [self.eventHandlers lookin_map:^id(NSUInteger idx, LookinEventHandler *value) {
        return value.copy;
    }];
    newDisplayItem.shouldCaptureImage = self.shouldCaptureImage;
    newDisplayItem.representedAsKeyWindow = self.representedAsKeyWindow;
    newDisplayItem.customDisplayTitle = self.customDisplayTitle;
    newDisplayItem.danceuiSource = self.danceuiSource;
    [newDisplayItem _updateDisplayingInHierarchyProperty];
    return newDisplayItem;
}
#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.customInfo forKey:@"customInfo"];
    [aCoder encodeObject:self.subitems forKey:@"subitems"];
    [aCoder encodeBool:self.isHidden forKey:@"hidden"];
    [aCoder encodeFloat:self.alpha forKey:@"alpha"];
    [aCoder encodeObject:self.viewObject forKey:@"viewObject"];
    [aCoder encodeObject:self.layerObject forKey:@"layerObject"];
    [aCoder encodeObject:self.hostViewControllerObject forKey:@"hostViewControllerObject"];
    [aCoder encodeObject:self.attributesGroupList forKey:@"attributesGroupList"];
    [aCoder encodeObject:self.customAttrGroupList forKey:@"customAttrGroupList"];
    [aCoder encodeBool:self.representedAsKeyWindow forKey:@"representedAsKeyWindow"];
    [aCoder encodeObject:self.eventHandlers forKey:@"eventHandlers"];
    [aCoder encodeBool:self.shouldCaptureImage forKey:@"shouldCaptureImage"];
    if (self.screenshotEncodeType == LookinDisplayItemImageEncodeTypeNSData) {
        [aCoder encodeObject:[self.soloScreenshot lookin_encodedObjectWithType:LookinCodingValueTypeImage] forKey:@"soloScreenshot"];
        [aCoder encodeObject:[self.groupScreenshot lookin_encodedObjectWithType:LookinCodingValueTypeImage] forKey:@"groupScreenshot"];
    } else if (self.screenshotEncodeType == LookinDisplayItemImageEncodeTypeImage) {
        [aCoder encodeObject:self.soloScreenshot forKey:@"soloScreenshot"];
        [aCoder encodeObject:self.groupScreenshot forKey:@"groupScreenshot"];
    }
    [aCoder encodeObject:self.customDisplayTitle forKey:@"customDisplayTitle"];
    [aCoder encodeObject:self.danceuiSource forKey:@"danceuiSource"];
#if TARGET_OS_IPHONE
    [aCoder encodeCGRect:self.frame forKey:@"frame"];
    [aCoder encodeCGRect:self.bounds forKey:@"bounds"];
    [aCoder encodeObject:self.backgroundColor.lks_rgbaComponents forKey:@"backgroundColor"];
    
#elif TARGET_OS_MAC
    [aCoder encodeRect:self.frame forKey:@"frame"];
    [aCoder encodeRect:self.bounds forKey:@"bounds"];
    [aCoder encodeObject:self.backgroundColor.lookin_rgbaComponents forKey:@"backgroundColor"];
#endif
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.customInfo = [aDecoder decodeObjectForKey:@"customInfo"];
        self.subitems = [aDecoder decodeObjectForKey:@"subitems"];
        self.isHidden = [aDecoder decodeBoolForKey:@"hidden"];
        self.alpha = [aDecoder decodeFloatForKey:@"alpha"];
        self.viewObject = [aDecoder decodeObjectForKey:@"viewObject"];
        self.layerObject = [aDecoder decodeObjectForKey:@"layerObject"];
        self.hostViewControllerObject = [aDecoder decodeObjectForKey:@"hostViewControllerObject"];
        self.attributesGroupList = [aDecoder decodeObjectForKey:@"attributesGroupList"];
        self.customAttrGroupList = [aDecoder decodeObjectForKey:@"customAttrGroupList"];
        self.representedAsKeyWindow = [aDecoder decodeBoolForKey:@"representedAsKeyWindow"];
        
        id soloScreenshotObj = [aDecoder decodeObjectForKey:@"soloScreenshot"];
        if (soloScreenshotObj) {
            if ([soloScreenshotObj isKindOfClass:[NSData class]]) {
                self.soloScreenshot = [soloScreenshotObj lookin_decodedObjectWithType:LookinCodingValueTypeImage];
            } else if ([soloScreenshotObj isKindOfClass:[LookinImage class]]) {
                self.soloScreenshot = soloScreenshotObj;
            } else {
                NSAssert(NO, @"");
            }
        }
        
        id groupScreenshotObj = [aDecoder decodeObjectForKey:@"groupScreenshot"];
        if (groupScreenshotObj) {
            if ([groupScreenshotObj isKindOfClass:[NSData class]]) {
                self.groupScreenshot = [groupScreenshotObj lookin_decodedObjectWithType:LookinCodingValueTypeImage];
            } else if ([groupScreenshotObj isKindOfClass:[LookinImage class]]) {
                self.groupScreenshot = groupScreenshotObj;
            } else {
                NSAssert(NO, @"");
            }            
        }
        
        self.eventHandlers = [aDecoder decodeObjectForKey:@"eventHandlers"];
        /// this property was added in LookinServer 1.1.3
        self.shouldCaptureImage = [aDecoder containsValueForKey:@"shouldCaptureImage"] ? [aDecoder decodeBoolForKey:@"shouldCaptureImage"] : YES;
        self.customDisplayTitle = [aDecoder decodeObjectForKey:@"customDisplayTitle"];
        self.danceuiSource = [aDecoder decodeObjectForKey:@"danceuiSource"];
#if TARGET_OS_IPHONE
        self.frame = [aDecoder decodeCGRectForKey:@"frame"];
        self.bounds = [aDecoder decodeCGRectForKey:@"bounds"];
        self.backgroundColor = [UIColor lks_colorFromRGBAComponents:[aDecoder decodeObjectForKey:@"backgroundColor"]];
#elif TARGET_OS_MAC
        self.frame = [aDecoder decodeRectForKey:@"frame"];
        self.bounds = [aDecoder decodeRectForKey:@"bounds"];
        self.backgroundColor = [NSColor lookin_colorFromRGBAComponents:[aDecoder decodeObjectForKey:@"backgroundColor"]];
        
#endif
        [self _updateDisplayingInHierarchyProperty];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    if (self = [super init]) {
        /// 在手机端，displayItem 被创建时会调用这个方法
        [self _updateDisplayingInHierarchyProperty];
    }
    return self;
}

- (LookinObject *)displayingObject {
    return self.viewObject ? : self.layerObject;
}

- (void)setAttributesGroupList:(NSArray<LookinAttributesGroup *> *)attributesGroupList {
    _attributesGroupList = attributesGroupList;
    
    [_attributesGroupList enumerateObjectsUsingBlock:^(LookinAttributesGroup * _Nonnull group, NSUInteger idx, BOOL * _Nonnull stop) {
        [group.attrSections enumerateObjectsUsingBlock:^(LookinAttributesSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
            [section.attributes enumerateObjectsUsingBlock:^(LookinAttribute * _Nonnull attr, NSUInteger idx, BOOL * _Nonnull stop) {
                attr.targetDisplayItem = self;
            }];
        }];
    }];
}

- (void)setCustomAttrGroupList:(NSArray<LookinAttributesGroup *> *)customAttrGroupList {
    _customAttrGroupList = customAttrGroupList;
    // 传进来的时候就已经排好序了
    [customAttrGroupList enumerateObjectsUsingBlock:^(LookinAttributesGroup * _Nonnull group, NSUInteger idx, BOOL * _Nonnull stop) {
        [group.attrSections enumerateObjectsUsingBlock:^(LookinAttributesSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
            [section.attributes enumerateObjectsUsingBlock:^(LookinAttribute * _Nonnull attr, NSUInteger idx, BOOL * _Nonnull stop) {
                attr.targetDisplayItem = self;
            }];
        }];
    }];
}

- (void)setSubitems:(NSArray<LookinDisplayItem *> *)subitems {
    [_subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.superItem = nil;
    }];
    
    _subitems = subitems;
    
    self.isExpandable = (subitems.count > 0);
    
    [subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(!obj.superItem, @"");
        obj.superItem = self;
        
        [obj _updateInHiddenHierarchyProperty];
        [obj _updateDisplayingInHierarchyProperty];
    }];
}

- (void)setIsExpandable:(BOOL)isExpandable {
    if (_isExpandable == isExpandable) {
        return;
    }
    _isExpandable = isExpandable;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsExpandable];
}

- (void)setIsExpanded:(BOOL)isExpanded {
    if (_isExpanded == isExpanded) {
        return;
    }
    _isExpanded = isExpanded;
    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateDisplayingInHierarchyProperty];
    }];
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsExpanded];
}

- (void)setSoloScreenshot:(LookinImage *)soloScreenshot {
    if (_soloScreenshot == soloScreenshot) {
        return;
    }
    _soloScreenshot = soloScreenshot;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_SoloScreenshot];
}

- (void)notifySelectionChangeToDelegates {
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsSelected];
}

- (void)notifyHoverChangeToDelegates {
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsHovered];
}

- (void)setDoNotFetchScreenshotReason:(LookinDoNotFetchScreenshotReason)doNotFetchScreenshotReason {
    if (_doNotFetchScreenshotReason == doNotFetchScreenshotReason) {
        return;
    }
    _doNotFetchScreenshotReason = doNotFetchScreenshotReason;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_AvoidSyncScreenshot];
}

- (void)setGroupScreenshot:(LookinImage *)groupScreenshot {
    if (_groupScreenshot == groupScreenshot) {
        return;
    }
    _groupScreenshot = groupScreenshot;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_GroupScreenshot];
}

- (void)setDisplayingInHierarchy:(BOOL)displayingInHierarchy {
    if (_displayingInHierarchy == displayingInHierarchy) {
        return;
    }
    _displayingInHierarchy = displayingInHierarchy;
    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateDisplayingInHierarchyProperty];
    }];
    
    [self _notifyDelegatesWith:LookinDisplayItemProperty_DisplayingInHierarchy];
}

- (void)_updateDisplayingInHierarchyProperty {
    if (self.superItem && (!self.superItem.displayingInHierarchy || !self.superItem.isExpanded)) {
        self.displayingInHierarchy = NO;
    } else {
        self.displayingInHierarchy = YES;
    }
}

- (void)setIsHidden:(BOOL)isHidden {
    _isHidden = isHidden;
    [self _updateInHiddenHierarchyProperty];
}

- (void)setAlpha:(float)alpha {
    _alpha = alpha;
    [self _updateInHiddenHierarchyProperty];
}

- (void)setInHiddenHierarchy:(BOOL)inHiddenHierarchy {
    if (_inHiddenHierarchy == inHiddenHierarchy) {
        return;
    }
    _inHiddenHierarchy = inHiddenHierarchy;
    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateInHiddenHierarchyProperty];
    }];
    
    [self _notifyDelegatesWith:LookinDisplayItemProperty_InHiddenHierarchy];
}

- (void)_updateInHiddenHierarchyProperty {
    if (self.superItem.inHiddenHierarchy || self.isHidden || self.alpha <= 0) {
        self.inHiddenHierarchy = YES;
    } else {
        self.inHiddenHierarchy = NO;
    }
}

+ (NSArray<LookinDisplayItem *> *)flatItemsFromHierarchicalItems:(NSArray<LookinDisplayItem *> *)items {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    [items enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.superItem) {
            obj.indentLevel = obj.superItem.indentLevel + 1;
        }
        [resultArray addObject:obj];
        if (obj.subitems.count) {
            [resultArray addObjectsFromArray:[self flatItemsFromHierarchicalItems:obj.subitems]];
        }
    }];
    
    return resultArray;
}

- (NSString *)description {
    if (self.viewObject) {
        return self.viewObject.rawClassName;
    } else if (self.layerObject) {
        return self.layerObject.rawClassName;
    } else {
        return [super description];
    }
}

- (void)setPreviewItemDelegate:(id<LookinDisplayItemDelegate>)previewItemDelegate {
    _previewItemDelegate = previewItemDelegate;
    
    if (![previewItemDelegate respondsToSelector:@selector(displayItem:propertyDidChange:)]) {
        NSAssert(NO, @"");
        _previewItemDelegate = nil;
        return;
    }
    [self.previewItemDelegate displayItem:self propertyDidChange:LookinDisplayItemProperty_None];
}

- (void)setRowViewDelegate:(id<LookinDisplayItemDelegate>)rowViewDelegate {
    if (_rowViewDelegate == rowViewDelegate) {
        return;
    }
    _rowViewDelegate = rowViewDelegate;
    
    if (![rowViewDelegate respondsToSelector:@selector(displayItem:propertyDidChange:)]) {
        NSAssert(NO, @"");
        _rowViewDelegate = nil;
        return;
    }
    [self.rowViewDelegate displayItem:self propertyDidChange:LookinDisplayItemProperty_None];
}

- (void)setFrame:(CGRect)frame {
    _frame = frame;
    [self recursivelyNotifyFrameToRootMayChange];
}

- (void)recursivelyNotifyFrameToRootMayChange {
    [self _notifyDelegatesWith:LookinDisplayItemProperty_FrameToRoot];

    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj recursivelyNotifyFrameToRootMayChange];
    }];
}

- (void)setBounds:(CGRect)bounds {
    _bounds = bounds;
    [self recursivelyNotifyFrameToRootMayChange];
}

- (void)setInNoPreviewHierarchy:(BOOL)inNoPreviewHierarchy {
    if (_inNoPreviewHierarchy == inNoPreviewHierarchy) {
        return;
    }
    _inNoPreviewHierarchy = inNoPreviewHierarchy;
    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateInNoPreviewHierarchy];
    }];
    [self _notifyDelegatesWith:LookinDisplayItemProperty_InNoPreviewHierarchy];
}

- (void)setNoPreview:(BOOL)noPreview {
    _noPreview = noPreview;
    [self _updateInNoPreviewHierarchy];
}

- (void)_updateInNoPreviewHierarchy {
    if (self.superItem.inNoPreviewHierarchy || self.noPreview) {
        self.inNoPreviewHierarchy = YES;
    } else {
        self.inNoPreviewHierarchy = NO;
    }
}

- (void)_notifyDelegatesWith:(LookinDisplayItemProperty)property {
    [self.previewItemDelegate displayItem:self propertyDidChange:property];
    [self.rowViewDelegate displayItem:self propertyDidChange:property];
}

- (void)setIsInSearch:(BOOL)isInSearch {
    _isInSearch = isInSearch;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsInSearch];
}

- (void)setHighlightedSearchString:(NSString *)highlightedSearchString {
    _highlightedSearchString = highlightedSearchString;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_HighlightedSearchString];
}

- (NSArray<LookinAttributesGroup *> *)queryAllAttrGroupList {
    NSMutableArray *array = [NSMutableArray array];
    if (self.attributesGroupList) {
        [array addObjectsFromArray:self.attributesGroupList];
    }
    if (self.customAttrGroupList) {
        [array addObjectsFromArray:self.customAttrGroupList];
    }
    return array;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
