//
//  LKS_PerspectiveHierarchyCell.m
//  LookinServer
//
//  Created by Li Kai on 2018/12/24.
//  https://lookin.work
//

#import "LKS_PerspectiveHierarchyCell.h"



#import "LookinDisplayItem.h"
#import "LookinIvarTrace.h"
#import "LookinServerDefines.h"

@interface LKS_PerspectiveHierarchyCell ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) CALayer *strikethroughLayer;

@property(nonatomic, assign) CGFloat cachedContentWidth;

@end

@implementation LKS_PerspectiveHierarchyCell {
    CGFloat _horInset;
    CGFloat _indicatorWidth;
    CGFloat _iconImageMarginLeft;
    CGFloat _indentUnitWidth;
    CGFloat _titleLeft;
    CGFloat _subtitleLeft;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _horInset = 10;
        _indicatorWidth = 15;
        _iconImageMarginLeft = 5;
        _indentUnitWidth = 10;
        _titleLeft = 6;
        _subtitleLeft = 10;
        
        _indicatorButton = [UIButton new];
        [self.contentView addSubview:self.indicatorButton];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.titleLabel];
        
        self.subtitleLabel = [UILabel new];
        self.subtitleLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicatorButton.frame = ({
        CGFloat x = self.displayItem.indentLevel * _indentUnitWidth + _horInset;
        CGRectMake(x, 0, _indicatorWidth, self.bounds.size.height);
    });
        
    self.titleLabel.frame = ({
        CGFloat width = self.titleLabel.lks_bestWidth;
        CGRectMake(CGRectGetMaxX(self.indicatorButton.frame) + _titleLeft, 0, width, self.bounds.size.height);
    });
    CGFloat labelMaxX = CGRectGetMaxX(self.titleLabel.frame);
    
    if (!self.subtitleLabel.hidden) {
        self.subtitleLabel.frame = ({
            CGFloat width = self.subtitleLabel.lks_bestWidth;
            CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + _subtitleLeft, 0, width, self.bounds.size.height);
        });
        labelMaxX = CGRectGetMaxX(self.subtitleLabel.frame);
    }
    if (self.strikethroughLayer && !self.strikethroughLayer.hidden) {
        self.strikethroughLayer.frame = ({
            CGFloat x = CGRectGetMinX(self.titleLabel.frame) - 2;
            CGFloat maxX = self.subtitleLabel.hidden ? (CGRectGetMaxX(self.titleLabel.frame) + 2) : (CGRectGetMaxX(self.subtitleLabel.frame) + 2);
            CGFloat width = maxX - x;
            CGRectMake(x, CGRectGetMidY(self.bounds), width, 1);
        });
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = self.cachedContentWidth;
    return size;
}

- (void)setDisplayItem:(LookinDisplayItem *)displayItem {
    _displayItem = displayItem;
    [self reRender];
}

- (void)reRender {
    // text
    self.titleLabel.text = self.displayItem.title;
    
    // subtitle
    self.subtitleLabel.text = self.displayItem.subtitle;
    self.subtitleLabel.hidden = (self.displayItem.subtitle.length == 0);
    
    // select
    if (self.displayItem.isSelected) {
        self.backgroundColor = LookinColorRGBAMake(172, 177, 191, .4);
        self.subtitleLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.textColor = LookinColorMake(133, 140, 150);
    }
 
    // icon
    if (!self.displayItem.isExpandable) {
        self.indicatorButton.hidden = YES;
    } else if (self.displayItem.isExpanded) {
        [self.indicatorButton setImage:[self _arrowDownImage] forState:UIControlStateNormal];
        self.indicatorButton.hidden = NO;
    } else {
        [self.indicatorButton setImage:[self _arrowRightImage] forState:UIControlStateNormal];
        self.indicatorButton.hidden = NO;
    }
    
    // strike
    if (self.displayItem.inNoPreviewHierarchy) {
        if (!self.strikethroughLayer) {
            self.strikethroughLayer = [CALayer layer];
            [self.strikethroughLayer lookin_removeImplicitAnimations];
            self.strikethroughLayer.backgroundColor = LookinColorRGBAMake(255, 255, 255, .3).CGColor;
            [self.layer addSublayer:self.strikethroughLayer];
        }
        self.strikethroughLayer.hidden = NO;
        
        if (self.displayItem.isSelected) {
            self.titleLabel.textColor = [UIColor whiteColor];
        } else {
            self.titleLabel.textColor = LookinColorMake(113, 120, 130);
        }
    } else {
        self.strikethroughLayer.hidden = YES;
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    
    [self setNeedsLayout];

    self.cachedContentWidth = ({
        CGFloat width = 0;
        width = _horInset + self.displayItem.indentLevel * _indentUnitWidth + _indicatorWidth + _iconImageMarginLeft + _titleLeft + self.titleLabel.lks_bestWidth + _horInset;
        if (!self.subtitleLabel.hidden) {
            width += self.subtitleLabel.lks_bestWidth + _subtitleLeft;
        }
        width;
    });
}

- (UIImage *)_arrowRightImage {
    static UIImage *image = nil;
    if (image) {
        return image;
    }
    
    CGFloat width = 10;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width - 2, width / 2.0)];
    [path addLineToPoint:CGPointMake(0, width)];
    [path closePath];
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [path fill];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)_arrowDownImage {
    static UIImage *image = nil;
    if (image) {
        return image;
    }
    
    CGFloat width = 10;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width / 2.0, width - 2)];
    [path closePath];
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [path fill];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
