//
//  LookinPreviewItemLayer.m
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import "LookinPreviewItemLayer.h"
#import "LookinDisplayItem.h"
#import "LKPreferenceManager.h"

@interface LookinPreviewItemUnselectableLayer : CALayer

@end

@implementation LookinPreviewItemUnselectableLayer

- (CALayer *)hitTest:(CGPoint)p {
    return nil;
}

@end

@interface LookinPreviewItemLayer ()

@property(nonatomic, strong) LookinPreviewItemUnselectableLayer *selectedMaskLayer;
@property(nonatomic, strong) LookinPreviewItemUnselectableLayer *contentLayer;

@property(nonatomic, strong) LKPreferenceManager *preferenceManager;

@end

@implementation LookinPreviewItemLayer

- (instancetype)initWithPreferenceManager:(LKPreferenceManager *)manager {
    if (self = [self init]) {
        self.preferenceManager = manager;

        self.borderWidth = 1;
        
        self.contentLayer = [LookinPreviewItemUnselectableLayer layer];
        [self addSublayer:self.contentLayer];
        
        self.selectedMaskLayer = [LookinPreviewItemUnselectableLayer layer];
        self.selectedMaskLayer.opacity = 0;
        [self addSublayer:self.selectedMaskLayer];
        
        NSDictionary<NSString *, id<CAAction>> *actions = @{NSStringFromSelector(@selector(bounds)) : [NSNull null],
                                                            NSStringFromSelector(@selector(position)) : [NSNull null],
                                                            NSStringFromSelector(@selector(borderColor)) : [NSNull null],
                                                            };
        self.actions = actions;
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    self.selectedMaskLayer.frame = self.bounds;
    self.contentLayer.frame = self.bounds;
}

- (void)setDisplayItem:(LookinDisplayItem *)displayItem {
    if (_displayItem == displayItem) {
        return;
    }
    _displayItem = displayItem;

    RACSubject *disposeSubject = [self lookin_getBindObjectForKey:NSStringFromSelector(_cmd)];
    if (!disposeSubject) {
        disposeSubject = [RACSubject subject];
        [self lookin_bindObject:disposeSubject forKey:NSStringFromSelector(_cmd)];
    }
    [disposeSubject sendNext:nil];
    
    
    // image, borderColor, backgroundColor
    @weakify(self);
    [[[[RACSignal combineLatest:@[RACObserve(displayItem, isExpandable),
                                  RACObserve(displayItem, isExpanded),
                                  RACObserve(displayItem, soloScreenshot),
                                  RACObserve(displayItem, groupScreenshot),
                                  RACObserve(displayItem, isSelected),
                                  RACObserve(displayItem, isHovered),
                                  RACObserve(displayItem, avoidSyncScreenshot),
                                  RACObserve(displayItem, soloScreenshotSyncError),
                                  RACObserve(displayItem, groupScreenshotSyncError),
                                  RACObserve(self.preferenceManager, showOutline)]]
       takeUntil:disposeSubject] distinctUntilChanged] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        self.contentLayer.contents = displayItem.appropriateScreenshot;
        BOOL hasFetchedScreenshot = !!displayItem.appropriateScreenshot;
        
        if (displayItem.isSelected || displayItem.isHovered) {
            if (hasFetchedScreenshot) {
                self.borderColor = [NSColor controlAccentColor].CGColor;
            } else {
                if (displayItem.avoidSyncScreenshot) {
                    self.borderColor = [NSColor systemRedColor].CGColor;
                } else {
                    self.borderColor = [NSColor systemOrangeColor].CGColor;
                }
            }
        } else if (!hasFetchedScreenshot) {
            if (displayItem.avoidSyncScreenshot) {
                self.borderColor = [[NSColor systemRedColor] colorWithAlphaComponent:.3].CGColor;
            } else {
                self.borderColor = [[NSColor systemOrangeColor] colorWithAlphaComponent:.3].CGColor;
            }
        } else if (self.preferenceManager.showOutline) {
            self.borderColor = LookinColorRGBAMake(160, 168, 189, .6).CGColor;
        } else {
            self.borderColor = [NSColor clearColor].CGColor;
        }
        
        if (displayItem.isSelected) {
            self.selectedMaskLayer.opacity = 1;
            
            NSColor *color;
            if (hasFetchedScreenshot) {
                color = [[NSColor controlAccentColor] colorWithAlphaComponent:.25];
            } else if (displayItem.avoidSyncScreenshot) {
                color = [[NSColor systemRedColor] colorWithAlphaComponent:.32];
            } else {
                color = [[NSColor systemOrangeColor] colorWithAlphaComponent:.25];
            }
            self.selectedMaskLayer.backgroundColor = color.CGColor;
            
        } else if (displayItem.isHovered) {
            self.selectedMaskLayer.opacity = 1;
            
            NSColor *color;
            if (hasFetchedScreenshot) {
                color = [[NSColor controlAccentColor] colorWithAlphaComponent:.05];
            } else if (displayItem.avoidSyncScreenshot) {
                color = [[NSColor systemRedColor] colorWithAlphaComponent:.25];
            } else {
                color = [[NSColor systemOrangeColor] colorWithAlphaComponent:.05];
            }
            self.selectedMaskLayer.backgroundColor = color.CGColor;
            
        } else {
            if (!hasFetchedScreenshot && displayItem.avoidSyncScreenshot) {
                self.selectedMaskLayer.opacity = 1;
                self.selectedMaskLayer.backgroundColor = [[NSColor systemRedColor] colorWithAlphaComponent:.17].CGColor;
            } else {
                self.selectedMaskLayer.opacity = 0;
            }
        }
    }];
    
    // frame
    [[[RACObserve(displayItem, frameToRoot) takeUntil:disposeSubject] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.frame = [x rectValue];
    }];
    
    // content opacity
    [[[[RACSignal combineLatest:@[RACObserve(displayItem, displayingInHierarchy),
                                  RACObserve(displayItem, inHiddenHierarchy),
                                  RACObserve(self.preferenceManager, isQuickSelecting),
                                  RACObserve(self.preferenceManager, showHiddenItems)]]
       takeUntil:disposeSubject] distinctUntilChanged] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        BOOL displayingInHierarchy = [((NSNumber *)x.first) boolValue];
        BOOL inHiddenHierarchy = [((NSNumber *)x.second) boolValue];
        BOOL showEvenWhenCollapsed = [((NSNumber *)x.third) boolValue] && !self.displayItem.superItem.preferToBeCollapsed;
        BOOL showHiddenItems = [((NSNumber *)x.fourth) boolValue];
        
        if (inHiddenHierarchy && !showHiddenItems) {
            self.opacity = 0;
            self.contentLayer.opacity = 0;
            
        } else if (displayingInHierarchy) {
            self.contentLayer.opacity = 1;
            self.opacity = 1;
            
        } else {
            self.contentLayer.opacity = 0;
            if (showEvenWhenCollapsed) {
                self.opacity = 1;
            } else {
                self.opacity = 0;
            }
        }
    }];
}

- (void)setZTranslation:(CGFloat)zTranslation {
    _zTranslation = zTranslation;
    self.transform = CATransform3DTranslate(CATransform3DIdentity, 0, self.yTranslation, self.zTranslation);
}

- (void)setYTranslation:(CGFloat)yTranslation {
    _yTranslation = yTranslation;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.transform = CATransform3DTranslate(CATransform3DIdentity, 0, self.yTranslation, self.zTranslation);
    [CATransaction commit];
}

- (CALayer *)hitTest:(CGPoint)p {
    if (self.hidden || self.opacity == 0) {
        return nil;
    }
    return [super hitTest:p];
}

@end
