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
    newDisplayItem.eventHandlers = [self.eventHandlers lookin_map:^id(NSUInteger idx, LookinEventHandler *value) {
        return value.copy;
    }];
    newDisplayItem.representedAsKeyWindow = self.representedAsKeyWindow;
    [newDisplayItem _updateDisplayingInHierarchyProperty];
    return newDisplayItem;
}
#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.subitems forKey:@"subitems"];
    [aCoder encodeBool:self.isHidden forKey:@"hidden"];
    [aCoder encodeFloat:self.alpha forKey:@"alpha"];
    [aCoder encodeObject:self.viewObject forKey:@"viewObject"];
    [aCoder encodeObject:self.layerObject forKey:@"layerObject"];
    [aCoder encodeObject:self.hostViewControllerObject forKey:@"hostViewControllerObject"];
    [aCoder encodeObject:self.attributesGroupList forKey:@"attributesGroupList"];
    [aCoder encodeBool:self.representedAsKeyWindow forKey:@"representedAsKeyWindow"];
    [aCoder encodeObject:self.eventHandlers forKey:@"eventHandlers"];
    if (self.screenshotEncodeType == LookinDisplayItemImageEncodeTypeNSData) {
        [aCoder encodeObject:[self.soloScreenshot lookin_encodedObjectWithType:LookinCodingValueTypeImage] forKey:@"soloScreenshot"];
        [aCoder encodeObject:[self.groupScreenshot lookin_encodedObjectWithType:LookinCodingValueTypeImage] forKey:@"groupScreenshot"];
    } else if (self.screenshotEncodeType == LookinDisplayItemImageEncodeTypeImage) {
        [aCoder encodeObject:self.soloScreenshot forKey:@"soloScreenshot"];
        [aCoder encodeObject:self.groupScreenshot forKey:@"groupScreenshot"];
    }
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
        self.subitems = [aDecoder decodeObjectForKey:@"subitems"];
        self.isHidden = [aDecoder decodeBoolForKey:@"hidden"];
        self.alpha = [aDecoder decodeFloatForKey:@"alpha"];
        self.viewObject = [aDecoder decodeObjectForKey:@"viewObject"];
        self.layerObject = [aDecoder decodeObjectForKey:@"layerObject"];
        self.hostViewControllerObject = [aDecoder decodeObjectForKey:@"hostViewControllerObject"];
        self.attributesGroupList = [aDecoder decodeObjectForKey:@"attributesGroupList"];
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

- (void)setAttributesGroupList:(NSSet<LookinAttributesGroup *> *)attributesGroupList {
    _attributesGroupList = [attributesGroupList copy];
    [attributesGroupList enumerateObjectsUsingBlock:^(LookinAttributesGroup * _Nonnull group, BOOL * _Nonnull stop) {
        [group.attrSections enumerateObjectsUsingBlock:^(LookinAttributesSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
            [section.attributes enumerateObjectsUsingBlock:^(LookinAttribute * _Nonnull attr, NSUInteger idx, BOOL * _Nonnull stop) {
                attr.targetDisplayItem = self;
            }];
        }];
    }];
}

- (BOOL)representedForSystemClass {
    return [self.title hasPrefix:@"UI"] || [self.title hasPrefix:@"CA"] || [self.title hasPrefix:@"_"];
}

- (BOOL)itemIsKindOfClassWithName:(NSString *)className {
    if (!className) {
        NSAssert(NO, @"");
        return NO;
    }
    return [self itemIsKindOfClassesWithNames:[NSSet setWithObject:className]];
}

- (BOOL)itemIsKindOfClassesWithNames:(NSSet<NSString *> *)targetClassNames {
    if (!targetClassNames.count) {
        return NO;
    }
    LookinObject *selfObj = self.viewObject ? : self.layerObject;
    if (!selfObj) {
        return NO;
    }
    
    __block BOOL boolValue = NO;
    [targetClassNames enumerateObjectsUsingBlock:^(NSString * _Nonnull targetClassName, BOOL * _Nonnull stop_outer) {
        [selfObj.classChainList enumerateObjectsUsingBlock:^(NSString * _Nonnull selfClass, NSUInteger idx, BOOL * _Nonnull stop_inner) {
            NSString *nonPrefixSelfClass = [selfClass componentsSeparatedByString:@"."].lastObject;
            if ([nonPrefixSelfClass isEqualToString:targetClassName]) {
                boolValue = YES;
                *stop_inner = YES;
            }
        }];
        if (boolValue) {
            *stop_outer = YES;
        }
    }];
    
    return boolValue;
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
        [obj _updateFrameToRoot];
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

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected == isSelected) {
        return;
    }
    _isSelected = isSelected;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsSelected];
}

- (void)setAvoidSyncScreenshot:(BOOL)avoidSyncScreenshot {
    if (_avoidSyncScreenshot == avoidSyncScreenshot) {
        return;
    }
    _avoidSyncScreenshot = avoidSyncScreenshot;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_AvoidSyncScreenshot];
}

- (void)setIsHovered:(BOOL)isHovered {
    if (_isHovered == isHovered) {
        return;
    }
    _isHovered = isHovered;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsHovered];
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

- (void)enumerateSelfAndAncestors:(void (^)(LookinDisplayItem *, BOOL *))block {
    if (!block) {
        return;
    }
    LookinDisplayItem *item = self;
    while (item) {
        BOOL shouldStop = NO;
        block(item, &shouldStop);
        if (shouldStop) {
            break;
        }
        item = item.superItem;
    }
}

- (void)enumerateAncestors:(void (^)(LookinDisplayItem *, BOOL *))block {
    [self.superItem enumerateSelfAndAncestors:block];
}

- (void)enumerateSelfAndChildren:(void (^)(LookinDisplayItem *item))block {
    if (!block) {
        return;
    }
    
    block(self);
    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull subitem, NSUInteger idx, BOOL * _Nonnull stop) {
        [subitem enumerateSelfAndChildren:block];
    }];
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
    return [NSString stringWithFormat:@"%@", self.title];
}

- (void)setFrameToRoot:(CGRect)frameToRoot {
    if (CGRectEqualToRect(_frameToRoot, frameToRoot)) {
        return;
    }
    _frameToRoot = frameToRoot;
    [(NSArray<LookinDisplayItem *> *)self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateFrameToRoot];
        [obj _updateInNoPreviewHierarchy];
    }];
    
    [self _notifyDelegatesWith:LookinDisplayItemProperty_FrameToRoot];
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
    [self _updateFrameToRoot];
}

- (void)setBounds:(CGRect)bounds {
    _bounds = bounds;
    [(NSArray<LookinDisplayItem *> *)self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateFrameToRoot];
    }];
}

- (void)_updateFrameToRoot {
    if (!self.superItem) {
        self.frameToRoot = self.frame;
        return;
    }
    CGRect superFrameToRoot = self.superItem.frameToRoot;
    CGRect superBounds = self.superItem.bounds;
    CGRect selfFrame = self.frame;
    
    CGFloat x = selfFrame.origin.x - superBounds.origin.x + superFrameToRoot.origin.x;
    CGFloat y = selfFrame.origin.y - superBounds.origin.y + superFrameToRoot.origin.y;
    
    CGFloat width = selfFrame.size.width;
    CGFloat height = selfFrame.size.height;
    self.frameToRoot = CGRectMake(x, y, width, height);
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

- (LookinImage *)appropriateScreenshot {
    if (self.isExpandable && self.isExpanded) {
        return self.soloScreenshot;
    }
    return self.groupScreenshot;
}

- (void)_notifyDelegatesWith:(LookinDisplayItemProperty)property {
    [self.previewItemDelegate displayItem:self propertyDidChange:property];
    [self.rowViewDelegate displayItem:self propertyDidChange:property];
}

- (BOOL)isMatchedWithSearchString:(NSString *)string {
    if (string.length == 0) {
        NSAssert(NO, @"");
        return NO;
    }
    if ([self.title.lowercaseString containsString:string.lowercaseString]) {
        return YES;
    }
    if ([self.subtitle.lowercaseString containsString:string.lowercaseString]) {
        return YES;
    }
    return NO;
}

- (void)setIsInSearch:(BOOL)isInSearch {
    _isInSearch = isInSearch;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_IsInSearch];
}

- (void)setHighlightedSearchString:(NSString *)highlightedSearchString {
    _highlightedSearchString = highlightedSearchString;
    [self _notifyDelegatesWith:LookinDisplayItemProperty_HighlightedSearchString];
}

- (void)setHostViewControllerObject:(LookinObject *)hostViewControllerObject {
    _hostViewControllerObject = hostViewControllerObject;
    [self _updateSubtitleProperty];
}

- (void)setViewObject:(LookinObject *)viewObject {
    _viewObject = viewObject;
    [self _updateSubtitleProperty];
    [self _updateTitleProperty];
}

- (void)setLayerObject:(LookinObject *)layerObject {
    _layerObject = layerObject;
    [self _updateSubtitleProperty];
    [self _updateTitleProperty];
}

- (void)_updateTitleProperty {
    if (self.viewObject) {
        _title = self.viewObject.shortSelfClassName;
    } else if (self.layerObject) {
        _title = self.layerObject.shortSelfClassName;
    } else {
        _title = nil;
    }
}

- (void)_updateSubtitleProperty {
    NSString *subtitle = @"";
    if (self.hostViewControllerObject.shortSelfClassName.length) {
        subtitle = [NSString stringWithFormat:@"%@.view", self.hostViewControllerObject.shortSelfClassName];
        
    } else {
        LookinObject *representedObject = self.viewObject ? : self.layerObject;
        if (representedObject.specialTrace.length) {
            subtitle = representedObject.specialTrace;
            
        } else if (representedObject.ivarTraces.count) {
            NSArray<NSString *> *ivarNameList = [representedObject.ivarTraces lookin_map:^id(NSUInteger idx, LookinIvarTrace *value) {
                return value.ivarName;
            }];
            subtitle = [[[NSSet setWithArray:ivarNameList] allObjects] componentsJoinedByString:@"   "];
        }
    }
    _subtitle = subtitle;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
