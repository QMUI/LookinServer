//
//  LKS_PerspectiveViewController.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//

#import "LKS_PerspectiveViewController.h"



#import "LKS_PerspectiveDataSource.h"
#import "LKS_PerspectiveLayer.h"
#import "LKS_PerspectiveHierarchyView.h"
#import "LKS_PerspectiveToolbarButtons.h"
#import "LKS_PerspectiveItemLayer.h"

#import "LookinServerDefines.h"

typedef NS_ENUM(NSUInteger, LKS_PerspectiveLayout) {
    LKS_PerspectiveLayoutFullScreen,
    LKS_PerspectiveLayoutHorizontal,
    LKS_PerspectiveLayoutVertical
};

@interface LKS_PerspectiveViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) LKS_PerspectiveLayer *previewLayer;
@property(nonatomic, strong) LKS_PerspectiveHierarchyView *hierarchyView;
@property(nonatomic, strong) LKS_PerspectiveToolbarDimensionButtonsView *dimensionButtonsView;
@property(nonatomic, strong) LKS_PerspectiveToolbarLayoutButtonsView *layoutButtonsView;
@property(nonatomic, strong) LKS_PerspectiveToolbarPropertyButton *propertyButton;

@property(nonatomic, strong) LKS_PerspectiveDataSource *dataSource;

@property(nonatomic, assign) LKS_PerspectiveLayout layoutType;

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *rotationGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *hierarchyDragGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *twoFingersGestureRecognizer;

/**
 当 layout 为 horizontal 时，该值表示 hierarchyView 最右侧的位置。
 当 layout 为 vertical 时，该值表示 hierarchyView 的最顶部的位置。
 当 layout 为 fullscreen 时，该值无意义
 */
@property(nonatomic, assign) CGFloat previewAndHierarchySepPosition;

@property(nonatomic, assign) CGFloat scale;
@property(nonatomic, assign) CGPoint translation;

@end

@implementation LKS_PerspectiveViewController {
    UIColor *_selectedButtonColor;
}

- (instancetype)initWithHierarchyInfo:(LookinHierarchyInfo *)info {
    if (self = [self initWithNibName:nil bundle:nil]) {
        self.dataSource = [[LKS_PerspectiveDataSource alloc] initWithHierarchyInfo:info];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedButtonColor = LookinColorMake(59, 130, 183);
    
    self.view.backgroundColor = LookinColorMake(31, 32, 34);
    
    self.previewLayer = [[LKS_PerspectiveLayer alloc] initWithDataSource:self.dataSource];
    [self.view.layer addSublayer:self.previewLayer];
    
    self.hierarchyView = [[LKS_PerspectiveHierarchyView alloc] initWithDataSource:self.dataSource];
    [self.view addSubview:self.hierarchyView];
    
    _closeButton = [LKS_PerspectiveToolbarCloseButton new];
    [self.view addSubview:self.closeButton];
    
    self.dimensionButtonsView = [LKS_PerspectiveToolbarDimensionButtonsView new];
    [self.dimensionButtonsView.button2D addTarget:self action:@selector(_handle2D) forControlEvents:UIControlEventTouchUpInside];
    [self.dimensionButtonsView.button3D addTarget:self action:@selector(_handle3D) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dimensionButtonsView];
    
    self.layoutButtonsView = [LKS_PerspectiveToolbarLayoutButtonsView new];
    [self.layoutButtonsView.verticalLayoutButton addTarget:self action:@selector(_handleVerticalLayout) forControlEvents:UIControlEventTouchUpInside];
    [self.layoutButtonsView.horizontalLayoutButton addTarget:self action:@selector(_handleHorizontalLayout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.layoutButtonsView];
    
    self.propertyButton = [LKS_PerspectiveToolbarPropertyButton new];
//    [self.view addSubview:self.propertyButton];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGesture:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    self.hierarchyDragGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleHierarchyDragGestureRecognizer:)];
#if TARGET_OS_TV
#else
    self.hierarchyDragGestureRecognizer.maximumNumberOfTouches = 1;
#endif
    self.hierarchyDragGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.hierarchyDragGestureRecognizer];
    
    self.rotationGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleRotationGestureRecognizer:)];
#if TARGET_OS_TV
#else
    self.rotationGestureRecognizer.maximumNumberOfTouches = 1;
#endif
    self.rotationGestureRecognizer.delegate = self;
    [self.rotationGestureRecognizer requireGestureRecognizerToFail:self.hierarchyDragGestureRecognizer];
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];
    
    self.twoFingersGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTwoFingersGestureRecognizer:)];
#if TARGET_OS_TV
#else
    self.twoFingersGestureRecognizer.minimumNumberOfTouches = 2;
    self.twoFingersGestureRecognizer.maximumNumberOfTouches = 2;
#endif
    [self.view addGestureRecognizer:self.twoFingersGestureRecognizer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _startEnterAnim];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.previewLayer.bounds = [UIScreen mainScreen].bounds;
    self.previewLayer.anchorPoint = CGPointMake(.5, .5);
    self.previewLayer.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    
    CGFloat buttonHeight = 30;
    CGFloat y = 20;
    if (@available(iOS 11, tvOS 11.0, *)) {
        y = MAX(self.view.safeAreaInsets.top, 20);
    }
    
    self.closeButton.frame = ({
        CGFloat x = 20;
        if (@available(iOS 11, tvOS 11.0, *)) {
            x = MAX(self.view.safeAreaInsets.left, 20);
        }
        CGRectMake(x, y, buttonHeight, buttonHeight);
    });
    
    CGFloat buttonGroupWidth = 70;
    self.layoutButtonsView.frame = ({
        CGFloat right = 20;
        if (@available(iOS 11, tvOS 11.0, *)) {
            right = MAX(self.view.safeAreaInsets.right, 20);
        }
        CGRectMake(self.view.bounds.size.width - right - buttonGroupWidth, y, buttonGroupWidth, buttonHeight);
    });
    self.dimensionButtonsView.frame = CGRectMake(CGRectGetMinX(self.layoutButtonsView.frame) - 15 - buttonGroupWidth, CGRectGetMinY(self.layoutButtonsView.frame), buttonGroupWidth, buttonHeight);
//    self.propertyButton.frame = CGRectMake(CGRectGetMinX(self.layoutButtonsView.frame) + 15, y, buttonHeight, buttonHeight);
    
    if (self.layoutType == LKS_PerspectiveLayoutFullScreen) {
        // preview 全屏
        self.hierarchyView.frame = CGRectZero;
        
    } else if (self.layoutType == LKS_PerspectiveLayoutVertical) {
        // 上下布局
        CGFloat width = self.view.bounds.size.width;
        self.hierarchyView.frame = CGRectMake(0, self.previewAndHierarchySepPosition, width, self.view.bounds.size.height - self.previewAndHierarchySepPosition);
        
    } else if (self.layoutType == LKS_PerspectiveLayoutHorizontal) {
        // 左右布局
        CGFloat height = self.view.bounds.size.height;
        self.hierarchyView.frame = CGRectMake(0, 0, self.previewAndHierarchySepPosition, height);
        
    } else {
        NSAssert(NO, @"");
    }
}

#pragma mark - Event Handler

- (void)_handleTapGesture:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    CALayer *layer = [self.view.layer hitTest:point];
    if ([layer isKindOfClass:[LKS_PerspectiveItemLayer class]]) {
        LookinDisplayItem *item = ((LKS_PerspectiveItemLayer *)layer).displayItem;
        if (self.dataSource.selectedItem != item) {
            self.dataSource.selectedItem = item;
        }
    }
}

- (void)_handleRotationGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGFloat initialRotation = self.previewLayer.rotation;
        [recognizer lookin_bindDouble:initialRotation forKey:@"initialRotation"];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat rotationVelocity = 0.01;
        CGFloat gestureRotationOffset = [recognizer translationInView:self.view].x * rotationVelocity;
        CGFloat initialRotation = [recognizer lookin_getBindDoubleForKey:@"initialRotation"];
        CGFloat currentRotation = initialRotation + gestureRotationOffset;
        [self.previewLayer setRotation:currentRotation animated:NO completion:nil];
    }
}

- (void)_handleHierarchyDragGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.layoutType == LKS_PerspectiveLayoutFullScreen) {
            self.layoutType = LKS_PerspectiveLayoutVertical;
//            self.layoutButtonsView.verticalLayoutButton.selected = YES;
            self.previewAndHierarchySepPosition = self.view.bounds.size.height;
        }
        [self.hierarchyView lookin_bindDouble:self.previewAndHierarchySepPosition forKey:@"initialSepPosition"];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat initialSepPosition = [self.hierarchyView lookin_getBindDoubleForKey:@"initialSepPosition"];
        if (self.layoutType == LKS_PerspectiveLayoutHorizontal) {
            CGFloat translationX = [recognizer translationInView:self.view].x;
            CGFloat maxSepPosition = self.view.bounds.size.width * .7;
            self.previewAndHierarchySepPosition = MIN(MAX(initialSepPosition + translationX, 0), maxSepPosition);
            
        } else {
            CGFloat translationY = [recognizer translationInView:self.view].y;
            CGFloat minSepPosition = self.view.bounds.size.height * .3;
            self.previewAndHierarchySepPosition = MAX(MIN(initialSepPosition + translationY, self.view.bounds.size.height), minSepPosition);
        }
        [self.view setNeedsLayout];
        
    } else {
        if (self.layoutType == LKS_PerspectiveLayoutHorizontal) {
            CGFloat minXToHideHierarchy = 100;
            if (self.previewAndHierarchySepPosition <= minXToHideHierarchy) {
                self.previewAndHierarchySepPosition = 0;
//                self.layoutButtonsView.horizontalLayoutButton.selected = NO;
                [UIView animateWithDuration:.2 animations:^{
                    [self.view setNeedsLayout];
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.layoutType = LKS_PerspectiveLayoutFullScreen;
                }];
            }
            
        } else if (self.layoutType == LKS_PerspectiveLayoutVertical) {
            // 当距离屏幕底部的值小于该值时，hierarchy 将自动隐藏
            CGFloat minBottomToHideHierarchy = 100;
            if (self.previewAndHierarchySepPosition >= self.view.bounds.size.height - minBottomToHideHierarchy) {
                self.previewAndHierarchySepPosition = self.view.bounds.size.height;
//                self.layoutButtonsView.verticalLayoutButton.selected = NO;
                [UIView animateWithDuration:.2 animations:^{
                    [self.view setNeedsLayout];
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.layoutType = LKS_PerspectiveLayoutFullScreen;
                }];
            }
        }
    }
}

- (void)_handleTwoFingersGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (recognizer.numberOfTouches != 2) {
            NSAssert(NO, @"");
            return;
        }
        CGPoint initialLoc0 = [recognizer locationOfTouch:0 inView:self.view];
        CGPoint initialLoc1 = [recognizer locationOfTouch:1 inView:self.view];
        
        [recognizer lookin_bindPoint:initialLoc0 forKey:@"initialLoc0"];
        [recognizer lookin_bindPoint:initialLoc1 forKey:@"initialLoc1"];
        [recognizer lookin_bindPoint:self.translation forKey:@"initialTranslation"];
        [recognizer lookin_bindDouble:self.scale forKey:@"initialScale"];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if ([recognizer numberOfTouches] != 2) {
            return;
        }
        CGPoint initialLoc0 = [recognizer lookin_getBindPointForKey:@"initialLoc0"];
        CGPoint initialLoc1 = [recognizer lookin_getBindPointForKey:@"initialLoc1"];
        CGPoint initialCenter = CGPointMake((initialLoc1.x - initialLoc0.x) / 2.0 + initialLoc0.x, (initialLoc1.y - initialLoc0.y) / 2.0 + initialLoc0.y);
        
        CGPoint currentLoc0 = [recognizer locationOfTouch:0 inView:self.view];
        CGPoint currentLoc1 = [recognizer locationOfTouch:1 inView:self.view];
        CGPoint currentCenter = CGPointMake((currentLoc1.x - currentLoc0.x) / 2.0 + currentLoc0.x, (currentLoc1.y - currentLoc0.y) / 2.0 + currentLoc0.y);
        
        CGPoint initialTranslation = [recognizer lookin_getBindPointForKey:@"initialTranslation"];
        CGPoint translationOffset = CGPointMake(currentCenter.x - initialCenter.x, currentCenter.y - initialCenter.y);
        [self setTranslation:CGPointMake(initialTranslation.x + translationOffset.x, initialTranslation.y + translationOffset.y) animated:NO];
        
        CGFloat initialTouchesDistance = hypot(ABS(initialLoc1.x - initialLoc0.x), ABS(initialLoc1.y - initialLoc0.y));
        CGFloat currentTouchesDistance = hypot(ABS(currentLoc1.x - currentLoc0.x), ABS(currentLoc1.y - currentLoc0.y));
        CGFloat initialScale = [recognizer lookin_getBindDoubleForKey:@"initialScale"];
        CGFloat currentScale = initialScale * (currentTouchesDistance / MAX(initialTouchesDistance, 1));
        [self setScale:currentScale animated:NO];
    } else {
        [recognizer lookin_clearBindForKey:@"initialLoc0"];
        [recognizer lookin_clearBindForKey:@"initialLoc1"];
    }
}

- (void)_handle2D { 
    [self.dimensionButtonsView.button2D setBackgroundColor:_selectedButtonColor];
    [self.dimensionButtonsView.button3D setBackgroundColor:nil];
    self.previewLayer.dimension = LKS_PerspectiveDimension2D;
}

- (void)_handle3D {
    [self.dimensionButtonsView.button2D setBackgroundColor:nil];
    [self.dimensionButtonsView.button3D setBackgroundColor:_selectedButtonColor];
    self.previewLayer.dimension = LKS_PerspectiveDimension3D;
}

- (void)_handleVerticalLayout {
    if (self.layoutType == LKS_PerspectiveLayoutVertical) {
        return;
    }
    self.layoutType = LKS_PerspectiveLayoutVertical;
    self.previewAndHierarchySepPosition = self.view.bounds.size.height - 300;
    [self.view setNeedsLayout];
}

- (void)_handleHorizontalLayout {
    if (self.layoutType == LKS_PerspectiveLayoutHorizontal) {
        return;
    }
    self.layoutType = LKS_PerspectiveLayoutHorizontal;
    self.previewAndHierarchySepPosition = 200;
    [self.view setNeedsLayout];
}

- (void)setLayoutType:(LKS_PerspectiveLayout)layoutType {
    _layoutType = layoutType;
    if (layoutType == LKS_PerspectiveLayoutHorizontal) {
        self.hierarchyView.isHorizontalLayout = YES;
    } else {
        self.hierarchyView.isHorizontalLayout = NO;
    }
    
    [self.layoutButtonsView.verticalLayoutButton setBackgroundColor:nil];
    [self.layoutButtonsView.horizontalLayoutButton setBackgroundColor:nil];
    if (layoutType == LKS_PerspectiveLayoutHorizontal) {
        [self.layoutButtonsView.horizontalLayoutButton setBackgroundColor:_selectedButtonColor];
    } else if (layoutType == LKS_PerspectiveLayoutVertical) {
        [self.layoutButtonsView.verticalLayoutButton setBackgroundColor:_selectedButtonColor];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.rotationGestureRecognizer) {
        BOOL canRotate = (self.previewLayer.dimension == LKS_PerspectiveDimension3D);
        return canRotate;

    } else if (gestureRecognizer == self.hierarchyDragGestureRecognizer) {
        if (self.layoutType == LKS_PerspectiveLayoutHorizontal) {
            CGFloat touchX = [touch locationInView:self.view].x;
            if (touchX > self.previewAndHierarchySepPosition) {
                return NO;
            }
        } else if (self.layoutType == LKS_PerspectiveLayoutVertical) {
            CGFloat touchY = [touch locationInView:self.view].y;
            if (touchY < self.previewAndHierarchySepPosition) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.hierarchyDragGestureRecognizer) {
        if (self.layoutType == LKS_PerspectiveLayoutFullScreen) {
            CGPoint translation = [self.hierarchyDragGestureRecognizer translationInView:self.view];
            if (ABS(translation.x) >= 1) {
                return NO;
            }
        }
    
    } else if (gestureRecognizer == self.twoFingersGestureRecognizer) {
        if (gestureRecognizer.numberOfTouches != 2) {
            return NO;
        }
    
    } else if (gestureRecognizer == self.tapGestureRecognizer) {
        CGPoint location = [self.tapGestureRecognizer locationInView:self.view];
        if (CGRectContainsPoint(self.hierarchyView.frame, location)) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Others

- (void)_startEnterAnim {
    [self _handle3D];
    [self.previewLayer setRotation:0 animated:NO completion:nil];
    self.closeButton.alpha = 0;
    self.dimensionButtonsView.alpha = 0;
    self.layoutButtonsView.alpha = 0;
    
#if TARGET_OS_TV
    BOOL isLandScape = YES;
#else
    BOOL isLandScape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
#endif
    if (isLandScape) {
        self.layoutType = LKS_PerspectiveLayoutHorizontal;
        self.previewAndHierarchySepPosition = 0;
    } else {
        self.layoutType = LKS_PerspectiveLayoutVertical;
        self.previewAndHierarchySepPosition = self.view.bounds.size.height;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self setScale:.6 animated:YES];
    [self setTranslation:CGPointMake(0, -60) animated:YES];
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.closeButton.alpha = 1;
        self.dimensionButtonsView.alpha = 1;
        self.layoutButtonsView.alpha = 1;

        if (isLandScape) {
            self.previewAndHierarchySepPosition = 200;
        } else {
            self.previewAndHierarchySepPosition = self.view.bounds.size.height - 130;
        }

        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.previewLayer setRotation:.5 animated:YES completion:nil];
    }];
}

- (void)setScale:(CGFloat)scale animated:(BOOL)animated {
    _scale = scale;
    [self _updateTransformAnimated:animated];
}

- (void)setTranslation:(CGPoint)translation animated:(BOOL)animated {
    _translation = translation;
    [self _updateTransformAnimated:animated];
}

- (void)_updateTransformAnimated:(BOOL)animated {
    CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, self.translation.x, self.translation.y, 0);
    transform = CATransform3DScale(transform, self.scale, self.scale, 1);
    
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    self.previewLayer.transform = transform;
    [CATransaction commit];
}

@end
