//
//  LKS_PerspectiveItemLayer.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//

#import "LKS_PerspectiveItemLayer.h"



@interface LKS_PerspectiveItemUnselectableLayer : CALayer

@end

@implementation LKS_PerspectiveItemUnselectableLayer

- (CALayer *)hitTest:(CGPoint)p {
    return nil;
}

@end

@interface LKS_PerspectiveItemLayer ()

@property(nonatomic, strong) LKS_PerspectiveItemUnselectableLayer *selectedMaskLayer;
@property(nonatomic, strong) LKS_PerspectiveItemUnselectableLayer *contentLayer;

@end

@implementation LKS_PerspectiveItemLayer

- (instancetype)init {
    if (self = [super init]) {
        self.borderWidth = 1;
        
        self.contentLayer = [LKS_PerspectiveItemUnselectableLayer layer];
        [self addSublayer:self.contentLayer];
        
        self.selectedMaskLayer = [LKS_PerspectiveItemUnselectableLayer layer];
        self.selectedMaskLayer.backgroundColor = LookinColorRGBAMake(74, 144, 226, .25).CGColor;
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
    _displayItem = displayItem;
    [self reRender];
}

- (void)reRender {
    if (!self.displayItem) {
        NSAssert(NO, @"");
        return;
    }
    
    if (self.displayItem.isExpandable && self.displayItem.isExpanded) {
        self.contentLayer.contents = (__bridge id)(self.displayItem.soloScreenshot.CGImage);
    } else {
        self.contentLayer.contents = (__bridge id)(self.displayItem.groupScreenshot.CGImage);
    }
    
    if (self.displayItem.isSelected) {
        self.selectedMaskLayer.opacity = 1;
        self.borderColor = LookinColorRGBAMake(74, 144, 226, 1).CGColor;
    } else {
        self.selectedMaskLayer.opacity = 0;
        self.borderColor = LookinColorRGBAMake(160, 168, 189, .6).CGColor;
    }
    
    if (self.displayItem.displayingInHierarchy && !self.displayItem.inHiddenHierarchy) {
        self.contentLayer.opacity = 1;
        self.opacity = 1;
    } else {
        self.opacity = 0;
        self.contentLayer.opacity = 0;
    }
}

- (CALayer *)hitTest:(CGPoint)p {
    if (self.hidden || self.opacity == 0) {
        return nil;
    }
    return [super hitTest:p];
}

@end
