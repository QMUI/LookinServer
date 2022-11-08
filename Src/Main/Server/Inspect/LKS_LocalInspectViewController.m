#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_LocalInspectViewController.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/15.
//  https://lookin.work
//

#import "LKS_LocalInspectViewController.h"
#import "LKS_LocalInspectPanelLabelView.h"
#import "LookinIvarTrace.h"
#import "LookinHierarchyInfo.h"
#import "UIImage+LookinServer.h"
#import "LookinServerDefines.h"
#import "UIColor+LookinServer.h"

static CGRect const kInvalidRect = (CGRect){-2, -2, 0, 0};

@interface LKS_LocalInspectViewController ()

@property(nonatomic, strong) CALayer *highlightLayer;
@property(nonatomic, strong) CALayer *referLayer;

@property(nonatomic, assign) CGRect highlightRect;
@property(nonatomic, assign) CGRect referRect;

@property(nonatomic, copy) NSArray<CALayer *> *rulerLayers;
@property(nonatomic, copy) NSArray<UILabel *> *rulerLabels;

@property(nonatomic, strong) UIButton *titleButton;

@property(nonatomic, strong) UIView *panelView;
@property(nonatomic, strong) LKS_LocalInspectPanelLabelView *titleLabelView;
@property(nonatomic, strong) NSArray<LKS_LocalInspectPanelLabelView *> *contentLabelViews;

@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation LKS_LocalInspectViewController {
    CGFloat _panelContentsMarginTop;
    CGFloat _panelInsetTop;
    CGFloat _panelInsetBottom;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _panelContentsMarginTop = 3;
    _panelInsetTop = 1;
    _panelInsetBottom = 5;
    
    self.view.layer.lks_isLookinPrivateLayer = YES;
    
    self.highlightLayer = [CALayer layer];
    self.highlightLayer.backgroundColor = [UIColor colorWithRed:69/255.0 green:143/255.0 blue:208/255.0 alpha:.4].CGColor;
    [self.highlightLayer lookin_removeImplicitAnimations];
    [self.view.layer addSublayer:self.highlightLayer];
    
    self.referLayer = [CALayer layer];
    self.referLayer.backgroundColor = [UIColor colorWithRed:69/255.0 green:143/255.0 blue:208/255.0 alpha:.09].CGColor;
    [self.referLayer lookin_removeImplicitAnimations];
    [self.view.layer addSublayer:self.referLayer];
    
    self.titleButton = [UIButton new];
    self.titleButton.hidden = YES;
    self.titleButton.clipsToBounds = YES;
    self.titleButton.contentEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
    self.titleButton.layer.backgroundColor = [UIColor colorWithRed:208/255.0 green:2/255.0 blue:27/255.0 alpha:9].CGColor;
    [self.titleButton addTarget:self action:@selector(_handleExitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.titleButton setAttributedTitle:({
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:LKS_Localized(@"Tap or swipe to inspect") attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@" | " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:.5], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:LKS_Localized(@"Exit") attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
        
        NSMutableAttributedString *combinedStr = [NSMutableAttributedString new];
        [combinedStr appendAttributedString:str1];
        [combinedStr appendAttributedString:str2];
        [combinedStr appendAttributedString:str3];
        combinedStr;
        
    }) forState:UIControlStateNormal];
    [self.view addSubview:self.titleButton];
    
    self.rulerLayers = [NSArray lookin_arrayWithCount:4 block:^id(NSUInteger idx) {
        CALayer *layer = [CALayer new];
        [layer lookin_removeImplicitAnimations];
        layer.backgroundColor = [UIColor colorWithRed:69/255.0 green:143/255.0 blue:208/255.0 alpha:.4].CGColor;
        [self.view.layer addSublayer:layer];
        return layer;
    }];
    
    self.rulerLabels = [NSArray lookin_arrayWithCount:4 block:^id(NSUInteger idx) {
        UILabel *label = [UILabel new];
        label.userInteractionEnabled = NO;
        label.backgroundColor = [UIColor colorWithRed:26/255.0 green:154/255.0 blue:251/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.clipsToBounds = YES;
        [self.view addSubview:label];
        return label;
    }];
    
    self.panelView = [UIView new];
    self.panelView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.9];
    self.panelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.panelView.layer.borderWidth = 1 / [[UIScreen mainScreen] scale];
    self.panelView.userInteractionEnabled = NO;
    self.panelView.layer.cornerRadius = 5;
    self.panelView.hidden = YES;
    [self.view addSubview:self.panelView];
    
    self.titleLabelView = [LKS_LocalInspectPanelLabelView new];
    self.titleLabelView.verInset = 10;
    self.titleLabelView.leftLabel.font = [UIFont boldSystemFontOfSize:13];
    self.titleLabelView.rightLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabelView.leftLabel.textColor = [UIColor blackColor];
    self.titleLabelView.rightLabel.textColor = [UIColor blackColor];
    self.titleLabelView.interspace = 20;
    [self.titleLabelView addBottomBorderLayer];
    [self.panelView addSubview:self.titleLabelView];
    
    self.contentLabelViews = [NSArray array];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapRecognizer:)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanRecognizer:)];
    [self.view addGestureRecognizer:self.panRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleEnterForegound) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.highlightLayer.frame = self.highlightRect;
    self.referLayer.frame = self.referRect;
    
    if (!self.panelView.hidden) {
        CGRect contentRect = CGRectEqualToRect(kInvalidRect, self.referRect) ? self.highlightRect : self.referRect;
        [self _layoutPanelViewWithContentRect:contentRect];
    }
    
    [self _renderAndLayoutRulersWithHighlightRect:self.highlightRect referRect:self.referRect];
    
    if (!self.titleButton.hidden) {
        [self _layoutTitleButtonReferToPanelView];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self clearContents];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)highlightLayer:(CALayer *)layer {
    BOOL isValidLayer = ([layer isKindOfClass:[CALayer class]] && self.view.window && layer.lks_window);
    if (!isValidLayer) {
        self.highlightRect = kInvalidRect;
        self.referRect = kInvalidRect;
        self.panelView.hidden = YES;
        [self.view setNeedsLayout];
        return;
    }
    
    self.highlightRect = [layer lks_frameInWindow:self.view.window];
    self.referRect = ({
        CALayer *referLayer = nil;
        CALayer *temp_referLayer = layer.superlayer;
        while (temp_referLayer) {
            if (temp_referLayer && !CGRectEqualToRect(temp_referLayer.bounds, layer.frame)) {
                referLayer = temp_referLayer;
                break;
            }
            temp_referLayer = temp_referLayer.superlayer;
        }
        referLayer ? [referLayer lks_frameInWindow:self.view.window] : kInvalidRect;
    });
    
    self.titleLabelView.leftLabel.text = [self _titleStringForLayer:layer];
    self.titleLabelView.rightLabel.text = [self _subtitleStringForLayer:layer];
    NSArray<NSArray<NSString *> *> *contents = [self _contentStringsForLayer:layer];
    
    self.contentLabelViews = [self.contentLabelViews lookin_resizeWithCount:contents.count add:^LKS_LocalInspectPanelLabelView *(NSUInteger idx) {
        LKS_LocalInspectPanelLabelView *view = [LKS_LocalInspectPanelLabelView new];
        view.verInset = 4;
        view.leftLabel.font = [UIFont systemFontOfSize:13];
        view.rightLabel.font = [UIFont systemFontOfSize:13];
        view.leftLabel.textColor = [UIColor grayColor];
        view.rightLabel.textColor = [UIColor blackColor];
        [self.panelView addSubview:view];
        return view;
        
    } remove:^(NSUInteger idx, LKS_LocalInspectPanelLabelView *obj) {
        [obj removeFromSuperview];
        
    } doNext:^(NSUInteger idx, LKS_LocalInspectPanelLabelView *obj) {
        NSArray<NSString *> *strings = contents[idx];
        obj.leftLabel.text = strings.firstObject;
        obj.rightLabel.text = strings.lastObject;
    }];
    self.panelView.hidden = NO;
    
    [self.view setNeedsLayout];
}

- (void)setShowTitleButton:(BOOL)showTitleButton {
    _showTitleButton = showTitleButton;
    if (showTitleButton) {
        self.titleButton.hidden = NO;
        [self _layoutTitleButtonReferToPanelView];
    } else {
        self.titleButton.hidden = YES;
        [self.titleButton.layer removeAllAnimations];
    }
}

- (void)startTitleButtonAnimIfNeeded {
    if (self.titleButton.hidden) {
        return;
    }
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anim.fromValue = (id)[UIColor colorWithRed:208/255.0 green:2/255.0 blue:27/255.0 alpha:9].CGColor;
    anim.toValue = (id)[UIColor colorWithRed:208/255.0 green:2/255.0 blue:27/255.0 alpha:.7].CGColor;
    anim.duration = .8;
    anim.repeatCount = HUGE_VALF;
    anim.autoreverses = YES;
    [self.titleButton.layer removeAllAnimations];
    [self.titleButton.layer addAnimation:anim forKey:nil];
}

#pragma mark - Setter

- (void)setReferRect:(CGRect)referRect {
    _referRect = referRect;
    [self _didSetReferOrHighlightLayer];
}

- (void)setHighlightRect:(CGRect)highlightRect {
    _highlightRect = highlightRect;
    [self _didSetReferOrHighlightLayer];
}

- (void)_didSetReferOrHighlightLayer {
    if (!CGRectEqualToRect(kInvalidRect, self.referRect) && !CGRectIntersectsRect(self.referRect, self.highlightRect)) {
        self.referLayer.backgroundColor = [UIColor colorWithRed:69/255.0 green:143/255.0 blue:208/255.0 alpha:.4].CGColor;
    } else {
        self.referLayer.backgroundColor = [UIColor colorWithRed:69/255.0 green:143/255.0 blue:208/255.0 alpha:.07].CGColor;
    }
}

#pragma mark - Layout

- (void)_layoutPanelViewWithContentRect:(CGRect)contentRect {
    if (CGRectEqualToRect(contentRect, CGRectNull)) {
        self.panelView.frame = kInvalidRect;
        return;
    }
    
    CGSize containerSize = self.view.bounds.size;
    
    CGFloat panelWidth = self.titleLabelView.lks_bestWidth;
    panelWidth = [self.contentLabelViews lookin_reduceCGFloat:^CGFloat(CGFloat accumulator, NSUInteger idx, LKS_LocalInspectPanelLabelView *obj) {
        return MAX(accumulator, obj.lks_bestWidth);
    } initialAccumlator:panelWidth];
    
    CGFloat screenInset = 10;
    panelWidth = MIN(panelWidth, containerSize.width - screenInset * 2);
    
    self.titleLabelView.frame = CGRectMake(0, _panelInsetTop, panelWidth, self.titleLabelView.lks_bestHeight);
    __block CGFloat posY = CGRectGetMaxY(self.titleLabelView.frame) + _panelContentsMarginTop;
    
    [self.contentLabelViews enumerateObjectsUsingBlock:^(LKS_LocalInspectPanelLabelView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, posY, panelWidth, obj.lks_bestHeight);
        posY = CGRectGetMaxY(obj.frame);
    }];
    posY += _panelInsetBottom;
    
    CGSize panelSize = CGSizeMake(panelWidth, posY);
    CGFloat panelMargin = 10;
    
    CGFloat panelY = ({
        CGFloat y = 0;
        
        CGFloat panelMinY = screenInset;
        if (@available(iOS 11.0, tvOS 11.0, *)) {
            panelMinY = self.view.safeAreaInsets.top;
        }
        
        CGFloat panelMinBottomNeeded = screenInset;
        if (@available(iOS 11.0, tvOS 11.0, *)) {
            panelMinBottomNeeded = self.view.safeAreaInsets.bottom;
        }
        panelMinBottomNeeded += panelSize.height;
        
        if (contentRect.origin.y - panelSize.height >= panelMinY) {
            // 放到目标上方
            y = contentRect.origin.y - panelMargin - panelSize.height;
        } else {
            CGFloat targetBottom = containerSize.height - CGRectGetMaxY(contentRect);
            if (targetBottom > panelMinBottomNeeded) {
                // 放到目标下方
                y = CGRectGetMaxY(contentRect) + panelMargin;
            } else {
                // 放到目标内部的上方
                y = contentRect.origin.y + panelMargin;
                if (@available(iOS 11.0, tvOS 11.0, *)) {
                    y = MAX(y, self.view.safeAreaInsets.top);
                }
            }
        }
        
        y;
    });
    
    CGFloat panelX = ({
        CGFloat x = 0;
        // 先尝试和目标居中
        x = CGRectGetMidX(contentRect) - panelSize.width / 2.0;
        if (x <= 0) {
            // 如果超出了左边屏幕，则挪到距离屏幕左边
            x = screenInset;
        } else if (x + panelSize.width > containerSize.width) {
            // 如果超出了右边屏幕，则挪到距离屏幕右边 labelMargin 的距离
            x = containerSize.width - screenInset - panelSize.width;
        }
        x;
    });
    self.panelView.frame = CGRectMake(panelX, panelY, panelSize.width, panelSize.height);
}

- (void)_renderAndLayoutRulersWithHighlightRect:(CGRect)highlightRect referRect:(CGRect)referRect {
    BOOL showRulers = !CGRectEqualToRect(highlightRect, kInvalidRect) && !CGRectEqualToRect(referRect, kInvalidRect);
    if (!showRulers) {
        [self.rulerLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectZero;
        }];
        [self.rulerLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectZero;
        }];
        return;
    }
    
    CGFloat horInset = 8;
    CGFloat verInset = 4;
    CALayer *layer = self.rulerLayers[0];
    UILabel *label = self.rulerLabels[0];
    
    // top
    if (CGRectGetMinY(highlightRect) > CGRectGetMinY(referRect)) {
        
        CGFloat value = 0;
        if (CGRectGetMinY(highlightRect) > CGRectGetMaxY(referRect)) {
            value = CGRectGetMinY(highlightRect) - CGRectGetMaxY(referRect);
        } else {
            value = CGRectGetMinY(highlightRect) - CGRectGetMinY(referRect);
        }
        layer.frame = CGRectMake(CGRectGetMidX(highlightRect), CGRectGetMinY(highlightRect) - value, 1, value);
        label.text = [NSString lookin_stringFromDouble:value decimal:1];;
        CGSize bestSize = label.lks_bestSize;
        CGSize adjustedSize = CGSizeMake(bestSize.width + horInset, bestSize.height + verInset);
        label.layer.cornerRadius = adjustedSize.height / 2.0;
        label.frame = CGRectMake(CGRectGetMaxX(layer.frame) + 2, CGRectGetMidY(layer.frame) - adjustedSize.height / 2.0, adjustedSize.width, adjustedSize.height);
    } else {
        layer.frame = CGRectZero;
        label.frame = CGRectZero;
    }
    
    // left
    layer = self.rulerLayers[1];
    label = self.rulerLabels[1];
    if (CGRectGetMinX(highlightRect) > CGRectGetMinX(referRect)) {
        CGFloat value = 0;
        if (CGRectGetMinX(highlightRect) > CGRectGetMaxX(referRect)) {
            value = CGRectGetMinX(highlightRect) - CGRectGetMaxX(referRect);
        } else {
            value = CGRectGetMinX(highlightRect) - CGRectGetMinX(referRect);
        }
        layer.frame = CGRectMake(CGRectGetMinX(highlightRect) - value, CGRectGetMidY(highlightRect), value, 1);
        label.text = [NSString lookin_stringFromDouble:value decimal:1];;
        CGSize bestSize = label.lks_bestSize;
        CGSize adjustedSize = CGSizeMake(bestSize.width + horInset, bestSize.height + verInset);
        label.layer.cornerRadius = adjustedSize.height / 2.0;
        label.frame = CGRectMake(CGRectGetMidX(layer.frame), CGRectGetMinY(layer.frame) - 2 - adjustedSize.height, adjustedSize.width, adjustedSize.height);
    } else {
        layer.frame = CGRectZero;
        label.frame = CGRectZero;
    }
    
    // bottom
    layer = self.rulerLayers[2];
    label = self.rulerLabels[2];
    if (CGRectGetMaxY(highlightRect) < CGRectGetMaxY(referRect)) {
        CGFloat value = 0;
        if (CGRectGetMaxY(highlightRect) < CGRectGetMinY(referRect)) {
            value = CGRectGetMinY(referRect) - CGRectGetMaxY(highlightRect);
        } else {
            value = CGRectGetMaxY(referRect) - CGRectGetMaxY(highlightRect);
        }
        layer.frame = CGRectMake(CGRectGetMidX(highlightRect), CGRectGetMaxY(highlightRect), 1, value);
        label.text = [NSString lookin_stringFromDouble:value decimal:1];;
        CGSize bestSize = label.lks_bestSize;
        CGSize adjustedSize = CGSizeMake(bestSize.width + horInset, bestSize.height + verInset);
        label.layer.cornerRadius = adjustedSize.height / 2.0;
        label.frame = CGRectMake(CGRectGetMaxX(layer.frame) + 2, CGRectGetMidY(layer.frame) - adjustedSize.height / 2.0, adjustedSize.width, adjustedSize.height);
    } else {
        layer.frame = CGRectZero;
        label.frame = CGRectZero;
    }
    
    // right
    layer = self.rulerLayers[3];
    label = self.rulerLabels[3];
    if (CGRectGetMaxX(highlightRect) < CGRectGetMaxX(referRect)) {
        CGFloat value = 0;
        if (CGRectGetMaxX(highlightRect) < CGRectGetMinX(referRect)) {
            value = CGRectGetMinX(referRect) - CGRectGetMaxX(highlightRect);
        } else {
            value = CGRectGetMaxX(referRect) - CGRectGetMaxX(highlightRect);
        }
        layer.frame = CGRectMake(CGRectGetMaxX(highlightRect), CGRectGetMidY(highlightRect), value, 1);
        label.text = [NSString lookin_stringFromDouble:value decimal:1];;
        CGSize bestSize = label.lks_bestSize;
        CGSize adjustedSize = CGSizeMake(bestSize.width + horInset, bestSize.height + verInset);
        label.layer.cornerRadius = adjustedSize.height / 2.0;
        label.frame = CGRectMake(CGRectGetMidX(layer.frame) - adjustedSize.width / 2.0, CGRectGetMinY(layer.frame) - 2 - adjustedSize.height, adjustedSize.width, adjustedSize.height);
    } else {
        layer.frame = CGRectZero;
        label.frame = CGRectZero;
    }
}

- (void)_layoutTitleButtonReferToPanelView {
    /**
     0: 放到屏幕顶部或底部都可以
     1：需要放到屏幕底部
     2: 需要放到屏幕顶部
     */
    NSUInteger positionType = 0;
    
    if (self.panelView.hidden) {
        positionType = 0;
    } else {
        if (CGRectGetMinY(self.panelView.frame) <= 200) {
            positionType = 1;
        } else if (CGRectGetMaxY(self.panelView.frame) >= self.view.bounds.size.height - 200) {
            positionType = 2;
        } else {
            positionType = 0;
        }
    }
    
    if (positionType == 0) {
        if (self.titleButton.frame.origin.y <= 0 || self.titleButton.frame.origin.y > self.view.bounds.size.height / 2.0) {
            positionType = 1;
        } else {
            positionType = 2;
        }
    }
    
    self.titleButton.frame = ({
        CGSize size = [self.titleButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGFloat x = self.view.bounds.size.width / 2.0 - size.width / 2.0;
        CGFloat y;
        if (positionType == 1) {
            // 放到屏幕底部
            if (@available(iOS 11.0, tvOS 11.0, *)) {
                y = self.view.bounds.size.height - size.height - MAX(self.view.safeAreaInsets.bottom, 20);
            } else {
                y = self.view.bounds.size.height - size.height - 20;
            }
        } else {
            NSAssert(positionType == 2, @"");
            // 放到屏幕顶部
            if (@available(iOS 11.0, tvOS 11.0, *)) {
                y = MAX(self.view.safeAreaInsets.top, 20);
            } else {
                y = 20;
            }
        }
        CGRectMake(x, y, size.width, size.height);
    });
    self.titleButton.layer.cornerRadius = self.titleButton.bounds.size.height / 2.0;
}

#pragma mark - Event Handler

- (void)_handleTapRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    UIView *view = [self _targetViewAtPoint:point];
    if (view) {
        [self highlightLayer:view.layer];
    } else {
        self.highlightRect = kInvalidRect;
        self.referRect = kInvalidRect;
        [self.view setNeedsLayout];
        
        NSLog(@"LookinServer - No valid view was found at tap position %@ in 2D inspecting.", NSStringFromCGPoint(point));
    }
}

- (void)_handlePanRecognizer:(UIPanGestureRecognizer *)recognizer {
    self.panelView.hidden = YES;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [recognizer locationInView:self.view];
        UIView *view = [self _targetViewAtPoint:point];
        
        if (view) {
            CGRect newHighlightRect = [view.layer lks_frameInWindow:self.view.window];
            CGFloat offsetX = ABS(CGRectGetMidX(self.highlightRect) - CGRectGetMidX(newHighlightRect));
            CGFloat offsetY = ABS(CGRectGetMidY(self.highlightRect) - CGRectGetMidY(newHighlightRect));
            if (offsetX > 200 || offsetY > 200) {
                self.highlightRect = newHighlightRect;
            }
        }
        self.referRect = kInvalidRect;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (CGRectEqualToRect(kInvalidRect, self.highlightRect)) {
            return;
        }
        
        CGPoint point = [recognizer locationInView:self.view];
        UIView *endView = [self _targetViewAtPoint:point];
        if (endView) {
            self.referRect = [endView.layer lks_frameInWindow:self.view.window];
        } else {
            self.referRect = kInvalidRect;
        }
        [self.view setNeedsLayout];
    }
}

- (void)_handleExitButton {
    if (self.didSelectExit) {
        self.didSelectExit();
    }
}

- (void)_handleEnterForegound {
    [self startTitleButtonAnimIfNeeded];
}

#pragma mark - Others

/// 该 point 是在 self.view 的坐标系下
- (UIView *)_targetViewAtPoint:(CGPoint)point {
    __block UIView *targetView = nil;
    
    [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (targetView) {
            *stop = YES;
            return;
        }
        if (self.includedWindows.count) {
            if (![self.includedWindows containsObject:window]) {
                return;
            }
        } else if ([self.excludedWindows containsObject:window]) {
            return;
        }
        
        if (window == self.view.window) {
            return;
        }
        if (window.hidden) {
            return;
        }
        
        CGPoint newPoint = [window convertPoint:point fromWindow:self.view.window];
        if (window == self.prevKeyWindow) {
            targetView = [window lks_subviewAtPoint:newPoint preferredClasses:[self _preferredClassesInSelecting]];
        } else {
            targetView = [window hitTest:point withEvent:nil];
        }
    }];
    
    if (!targetView) {
        return nil;
    }
    
    // 特殊处理一下
    if ([NSStringFromClass([targetView class]) isEqualToString:@"UITableViewCellContentView"] && [targetView.superview isKindOfClass:[UITableViewCell class]]) {
        targetView = targetView.superview;
        
    } else if ([targetView.superview isKindOfClass:[UITableView class]] && targetView == ((UITableView *)targetView.superview).backgroundView) {
        targetView = targetView.superview;
    }
    
    return targetView;
}

- (NSArray<Class> *)_preferredClassesInSelecting {
    static dispatch_once_t onceToken;
    static NSArray<Class> *classes = nil;
    dispatch_once(&onceToken,^{
#if TARGET_OS_TV
        NSMutableArray<Class> *array = @[[UILabel class], [UIProgressView class], [UIActivityIndicatorView class], [UITextView class], [UITextField class], [UIVisualEffectView class]].mutableCopy;
#else
        NSMutableArray<Class> *array = @[[UILabel class], [UIProgressView class], [UIActivityIndicatorView class], [UITextView class], [UITextField class], [UISlider class], [UISwitch class], [UIVisualEffectView class]].mutableCopy;
#endif
        NSArray<NSString *> *custom = [LookinHierarchyInfo collapsedClassList];
        if (custom.count) {
            NSArray<Class> *customClasses = [custom lookin_map:^id(NSUInteger idx, NSString *value) {
                return NSClassFromString(value);
            }];
            [array addObjectsFromArray:customClasses];
        }
        classes = array;
    });
    return classes;
}

- (void)clearContents {
    self.highlightRect = kInvalidRect;
    self.referRect = kInvalidRect;
    self.panelView.hidden = YES;
    [self.view setNeedsLayout];
}

#pragma mark - Strings

- (NSString *)_titleStringForLayer:(CALayer *)layer {
    NSObject *targetObject = layer.lks_hostView ? : layer;
    NSString *classNameString = NSStringFromClass([targetObject class]) ? : @"";
    return classNameString;
}

- (NSString *)_subtitleStringForLayer:(CALayer *)layer {
    NSString *traceString = nil;
    
    NSObject *targetObject = layer.lks_hostView ? : layer;
    if (layer.lks_hostView.lks_hostViewController) {
        traceString = [NSString stringWithFormat:@"%@.view", NSStringFromClass([layer.lks_hostView.lks_hostViewController class])];
    } else {
        if (targetObject.lks_specialTrace.length) {
            traceString = targetObject.lks_specialTrace;
        } else if (targetObject.lks_ivarTraces.count) {
            traceString = [[[targetObject.lks_ivarTraces lookin_map:^id(NSUInteger idx, LookinIvarTrace *value) {
                return value.ivarName;
            }] lookin_nonredundantArray] componentsJoinedByString:@", "];
        }
    }
    
    return traceString;
}

- (NSArray<NSArray<NSString *> *> *)_contentStringsForLayer:(CALayer *)layer {
    NSMutableArray<NSArray<NSString *> *> *resultArray = [NSMutableArray array];
    
    [resultArray addObject:@[@"Frame", [NSString lookin_stringFromRect:layer.frame]]];
    
    if (layer.backgroundColor) {
        [resultArray addObject:@[@"BackgroundColor", [NSString lookin_rgbaStringFromColor:[UIColor lks_colorWithCGColor:layer.backgroundColor]]]];
    }
    if ([layer.lks_hostView isKindOfClass:[UIImageView class]]) {
        UIImage *image = ((UIImageView *)layer.lks_hostView).image;
        if (image.lks_imageSourceName.length) {
            [resultArray addObject:@[@"ImageName", [NSString stringWithFormat:@"\"%@\"", image.lks_imageSourceName]]];
        }
        
    } else if ([layer.lks_hostView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)layer.lks_hostView;
        // 不要直接访问 button.titleLabel。因为如果 title 不存在的话，访问 button.titleLabel 会触发初始化 titleLabel 进而触发 dynamic hierarhy push
        if ([button titleForState:UIControlStateNormal].length) {
            [resultArray addObject:@[@"FontSize", [NSString lookin_stringFromDouble:button.titleLabel.font.pointSize decimal:2]]];
            [resultArray addObject:@[@"FontName", button.titleLabel.font.fontName]];
            [resultArray addObject:@[@"TextColor", [NSString lookin_rgbaStringFromColor:button.titleLabel.textColor]]];
        }
        // 不要直接访问 button.imageView。因为如果 image 不存在的话，访问 button.image 会触发初始化 imageView 进而触发 dynamic hierarhy push
        if ([button imageForState:UIControlStateNormal]) {
            NSString *imageSourceName = button.imageView.image.lks_imageSourceName;
            if (imageSourceName.length) {
                [resultArray addObject:@[@"ImageName", [NSString stringWithFormat:@"\"%@\"", imageSourceName]]];
            }
        }
        
    } else if ([layer.lks_hostView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)layer.lks_hostView;
        [resultArray addObject:@[@"FontSize", [NSString lookin_stringFromDouble:label.font.pointSize decimal:2]]];
        [resultArray addObject:@[@"FontName", label.font.fontName]];
        [resultArray addObject:@[@"TextColor", [NSString lookin_rgbaStringFromColor:label.textColor]]];
        [resultArray addObject:@[@"NumberOfLines", [NSString stringWithFormat:@"%@", @(label.numberOfLines)]]];
        
    } else if ([layer.lks_hostView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)layer.lks_hostView;
        [resultArray addObject:@[@"ContentSize", [NSString lookin_stringFromSize:scrollView.contentSize]]];
        [resultArray addObject:@[@"ContentOffset", [NSString lookin_stringFromPoint:scrollView.contentOffset]]];
        [resultArray addObject:@[@"ContentInset", [NSString lookin_stringFromInset:scrollView.contentInset]]];
        if (@available(iOS 11.0, tvOS 11.0, *)) {
            [resultArray addObject:@[@"AdjustedContentInset", [NSString lookin_stringFromInset:scrollView.adjustedContentInset]]];
        }
        
        if ([scrollView isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)scrollView;
            [resultArray addObject:@[@"FontSize", [NSString lookin_stringFromDouble:textView.font.pointSize decimal:2]]];
            [resultArray addObject:@[@"FontName", textView.font.fontName]];
            [resultArray addObject:@[@"TextColor", [NSString lookin_rgbaStringFromColor:textView.textColor]]];
        }
        
    } else if ([layer.lks_hostView isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)layer.lks_hostView;
        [resultArray addObject:@[@"FontSize", [NSString lookin_stringFromDouble:textField.font.pointSize decimal:2]]];
        [resultArray addObject:@[@"FontName", textField.font.fontName]];
        [resultArray addObject:@[@"TextColor", [NSString lookin_rgbaStringFromColor:textField.textColor]]];
        
    }
    
    if (layer.borderColor && layer.borderWidth > 0) {
        [resultArray addObject:@[@"BorderColor", [NSString lookin_rgbaStringFromColor:[UIColor lks_colorWithCGColor:layer.borderColor]]]];
        [resultArray addObject:@[@"BorderWidth", [NSString lookin_stringFromDouble:layer.borderWidth decimal:2]]];
    }
    
    if (layer.cornerRadius > 0) {
        [resultArray addObject:@[@"CornerRadius", [NSString lookin_stringFromDouble:layer.cornerRadius decimal:2]]];
    }
    
    if (layer.opacity < 1) {
        [resultArray addObject:@[@"Opacity", [NSString lookin_stringFromDouble:layer.opacity decimal:2]]];
    }
    
    if (layer.shadowColor && layer.shadowOpacity > 0) {
        [resultArray addObject:@[@"ShadowColor", [NSString lookin_rgbaStringFromColor:[UIColor lks_colorWithCGColor:layer.shadowColor]]]];
        [resultArray addObject:@[@"ShadowOpacity", [NSString lookin_stringFromDouble:layer.shadowOpacity decimal:2]]];
        [resultArray addObject:@[@"ShadowOffset", [NSString lookin_stringFromSize:layer.shadowOffset]]];
        [resultArray addObject:@[@"ShadowRadius", [NSString lookin_stringFromDouble:layer.shadowRadius decimal:2]]];
    }
    
    return resultArray;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
