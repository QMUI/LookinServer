//
//  LookinDisplayItem.m
//  
//
//  
//

#import "LookinDisplayItem.h"
#import "LookinAttributesGroup.h"
#import "LookinAttributesSection.h"
#import "LookinAttribute.h"

@interface LookinDisplayItem ()

@property(nonatomic, assign, readwrite) CGRect frameToRoot;
@property(nonatomic, assign, readwrite) BOOL inNoPreviewHierarchy;
@property(nonatomic, assign) NSInteger indentLevel;
@property(nonatomic, assign, readwrite) BOOL isExpandable;
@property(nonatomic, assign, readwrite) BOOL inHiddenHierarchy;
@property(nonatomic, assign, readwrite) BOOL displayingInHierarchy;

@end

@implementation LookinDisplayItem

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.subitems forKey:@"subitems"];
    [aCoder encodeBool:self.isHidden forKey:@"hidden"];
    [aCoder encodeFloat:self.alpha forKey:@"alpha"];
    [aCoder encodeObject:self.viewObject forKey:@"viewObject"];
    [aCoder encodeObject:self.layerObject forKey:@"layerObject"];
    [aCoder encodeObject:self.hostViewControllerObject forKey:@"hostViewControllerObject"];
    [aCoder encodeObject:self.attributesGroupList forKey:@"attributesGroupList"];
    [aCoder encodeBool:self.representedAsKeyWindow forKey:@"representedAsKeyWindow"];
    if (self.shouldEncodeScreenshot) {
        [aCoder encodeObject:[self.soloScreenshot lookin_encodedObjectWithType:LookinCodingValueTypeImage] forKey:@"soloScreenshot"];
        [aCoder encodeObject:[self.groupScreenshot lookin_encodedObjectWithType:LookinCodingValueTypeImage] forKey:@"groupScreenshot"];
    }
#if TARGET_OS_IPHONE
    [aCoder encodeCGRect:self.frame forKey:@"frame"];
    [aCoder encodeCGRect:self.bounds forKey:@"bounds"];
    
#elif TARGET_OS_MAC
    [aCoder encodeRect:self.frame forKey:@"frame"];
    [aCoder encodeRect:self.bounds forKey:@"bounds"];
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
        self.soloScreenshot = [[aDecoder decodeObjectForKey:@"soloScreenshot"] lookin_decodedObjectWithType:LookinCodingValueTypeImage];
        self.groupScreenshot = [[aDecoder decodeObjectForKey:@"groupScreenshot"] lookin_decodedObjectWithType:LookinCodingValueTypeImage];
#if TARGET_OS_IPHONE
        self.frame = [aDecoder decodeCGRectForKey:@"frame"];
        self.bounds = [aDecoder decodeCGRectForKey:@"bounds"];
#elif TARGET_OS_MAC
        self.frame = [aDecoder decodeRectForKey:@"frame"];
        self.bounds = [aDecoder decodeRectForKey:@"bounds"];
        
        static NSSet<NSString *> *defaultNoPreviewClasses;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            defaultNoPreviewClasses = [NSSet setWithArray:@[@"UITextEffectsWindow", @"UIRemoteKeyboardWindow", @"LKS_LocalInspectContainerWindow"]];
        });
        if ([self itemIsKindOfClassesWithNames:defaultNoPreviewClasses]) {
            self.noPreview = YES;
        } else {
            self.noPreview = NO;
        }
#endif
        
        [self _updateDisplayingInHierarchyProperty];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _updateDisplayingInHierarchyProperty];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSString *)title {
    if (self.viewObject) {
        return self.viewObject.nonNamespaceSelfClassName;
    }
    if (self.layerObject) {
        return self.layerObject.nonNamespaceSelfClassName;
    }
    NSAssert(NO, @"");
    return nil;
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

- (void)setIsExpanded:(BOOL)isExpanded {
    if (_isExpanded == isExpanded) {
        return;
    }
    _isExpanded = isExpanded;
    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateDisplayingInHierarchyProperty];
    }];
}

- (void)setDisplayingInHierarchy:(BOOL)displayingInHierarchy {
    if (_displayingInHierarchy == displayingInHierarchy) {
        return;
    }
    _displayingInHierarchy = displayingInHierarchy;
    [self.subitems enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _updateDisplayingInHierarchyProperty];
    }];
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
        [resultArray addObject:obj];
        if (obj.subitems.count) {
            [resultArray addObjectsFromArray:[self flatItemsFromHierarchicalItems:obj.subitems]];
        }
    }];
    
    return resultArray;
}

+ (void)setUpIndentLevelForFlatItems:(NSArray<LookinDisplayItem *> *)items {
    [items enumerateObjectsUsingBlock:^(LookinDisplayItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.indentLevel = 0;
        [item enumerateAncestors:^(LookinDisplayItem *ancestorItem, BOOL *stop) {
            item.indentLevel++;
        }];
    }];
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

@end
