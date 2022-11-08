#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_PerspectiveToolbarButtons.m
//  qmuidemo
//
//  Created by Li Kai on 2018/12/20.
//  Copyright © 2018 QMUI Team. All rights reserved.
//

#import "LKS_PerspectiveToolbarButtons.h"



static CGFloat const kConerRadius = 6;

@implementation LKS_PerspectiveToolbarCloseButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setImage:[self _image] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = kConerRadius;
    }
    return self;
}

- (UIImage *)_image {
    CGFloat width = 13;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width, width)];
    [path moveToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(0, width)];
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    [path setLineWidth:1];
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation LKS_PerspectiveToolbarDimensionButtonsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = kConerRadius;
        self.clipsToBounds = YES;

        _button2D = [UIButton new];
        [self.button2D setImage:[self _image2D] forState:UIControlStateNormal];
        [self addSubview:self.button2D];

        _button3D = [UIButton new];
        [self.button3D setImage:[self _image3D] forState:UIControlStateNormal];
        [self addSubview:self.button3D];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat halfWidth = self.bounds.size.width / 2.0;
    CGFloat height = self.bounds.size.height;
    self.button2D.frame = CGRectMake(0, 0, halfWidth, height);
    self.button3D.frame = CGRectMake(halfWidth, 0, halfWidth, height);
}

- (UIImage *)_image2D {
    CGFloat width = 16;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(1, 1)];
    [path addLineToPoint:CGPointMake(width - 1, 1)];
    [path addLineToPoint:CGPointMake(width - 1, width - 1)];
    [path addLineToPoint:CGPointMake(1, width - 1)];
    [path closePath];
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    [path setLineWidth:1];
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)_image3D {
    CGFloat width = 16;
    CGFloat height = 18;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width / 2.0, 1)];
    [path addLineToPoint:CGPointMake(width - 1, 4)];
    [path addLineToPoint:CGPointMake(width / 2.0, 7)];
    [path addLineToPoint:CGPointMake(1, 4)];
    [path closePath];
    
    [path moveToPoint:CGPointMake(1, 4)];
    [path addLineToPoint:CGPointMake(1, height - 4)];
    [path addLineToPoint:CGPointMake(width / 2.0, height - 1)];
    [path addLineToPoint:CGPointMake(width - 1, height - 4)];
    [path addLineToPoint:CGPointMake(width - 1, 4)];
    
    [path moveToPoint:CGPointMake(width / 2.0, 7)];
    [path addLineToPoint:CGPointMake(width / 2.0, height - 1)];
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    [path setLineWidth:1];
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation LKS_PerspectiveToolbarLayoutButtonsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = kConerRadius;
        self.clipsToBounds = YES;
        
        _verticalLayoutButton = [UIButton new];
        [self.verticalLayoutButton setImage:[self _imageVertical] forState:UIControlStateNormal];
        [self addSubview:self.verticalLayoutButton];
        
        _horizontalLayoutButton = [UIButton new];
        [self.horizontalLayoutButton setImage:[self _imageHorizontal] forState:UIControlStateNormal];
        [self addSubview:self.horizontalLayoutButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat halfWidth = self.bounds.size.width / 2.0;
    CGFloat height = self.bounds.size.height;
    self.verticalLayoutButton.frame = CGRectMake(0, 0, halfWidth, height);
    self.horizontalLayoutButton.frame = CGRectMake(halfWidth, 0, halfWidth, height);
}

- (UIImage *)_imageHorizontal {
    CGFloat width = 19;
    CGFloat height = 17;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect outRect = CGRectMake(1, 1, width - 2, height - 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:outRect];
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    [path setLineWidth:1];
    [path stroke];

    path = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(outRect) + 3, CGRectGetMinY(outRect) + 3, 2, CGRectGetHeight(outRect) - 6)];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [path fill];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)_imageVertical {
    CGFloat width = 19;
    CGFloat height = 17;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect outRect = CGRectMake(1, 1, width - 2, height - 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:outRect];
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    [path setLineWidth:1];
    [path stroke];
    
    path = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(outRect) + 3, CGRectGetMaxY(outRect) - 5, CGRectGetWidth(outRect) - 6, 2)];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation LKS_PerspectiveToolbarPropertyButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setImage:[self _image] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = kConerRadius;
    }
    return self;
}

- (UIImage *)_image {
    CGFloat width = 20;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat ovalRadius = 3;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width / 2.0 - ovalRadius / 2.0, 4, ovalRadius, ovalRadius)];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [path fill];
  
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width / 2.0, 9)];
    [path addLineToPoint:CGPointMake(width / 2.0, width - 4)];
    [path setLineWidth:2];
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    [path stroke];
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, width - 2, width - 2)];
    [path setLineWidth:1];
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
