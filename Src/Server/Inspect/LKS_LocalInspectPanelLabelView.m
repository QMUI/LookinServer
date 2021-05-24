//
//  LKS_LocalInspectPanelLabelView.m
//  LookinServer
//
//  Created by Li Kai on 2019/5/15.
//  https://lookin.work
//

#import "LKS_LocalInspectPanelLabelView.h"
#import "LookinServerDefines.h"

@implementation LKS_LocalInspectPanelLabelView {
    CGFloat _horInset;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _horInset = 8;
        _interspace = 10;
        
        self.userInteractionEnabled = NO;
        
        self.leftLabel = [UILabel new];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.leftLabel];
        
        self.rightLabel = [UILabel new];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftLabel.frame = CGRectMake(_horInset, 0, self.leftLabel.lks_bestWidth, self.bounds.size.height);
    
    if (self.rightLabel.text.length) {
        CGFloat rightLabelWidth = self.bounds.size.width - _horInset - _interspace - CGRectGetMaxX(self.leftLabel.frame);
        if (rightLabelWidth <= 0) {
            self.rightLabel.frame = CGRectZero;
        } else {
            self.rightLabel.frame = CGRectMake(CGRectGetMaxX(self.leftLabel.frame) + _interspace, 0, rightLabelWidth, self.bounds.size.height);
        }
    }
    
    self.bottomBorderLayer.frame = CGRectMake(_horInset, self.bounds.size.height, self.bounds.size.width - _horInset * 2, 1 / [[UIScreen mainScreen] scale]);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize leftSize = [self.leftLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    size.height = leftSize.height + self.verInset;
    size.width = _horInset * 2 + leftSize.width;
    if (self.rightLabel.text.length) {
        size.width += self.rightLabel.lks_bestWidth + _interspace;
    }
    return size;
}

- (void)addBottomBorderLayer {
    if (self.bottomBorderLayer) {
        return;
    }
    self.bottomBorderLayer = [CALayer new];
    [self.bottomBorderLayer lookin_removeImplicitAnimations];
    self.bottomBorderLayer.backgroundColor = [UIColor colorWithRed:222/255.0 green:224/255.0 blue:226/255.0 alpha:1].CGColor;
    [self.layer addSublayer:self.bottomBorderLayer];
}

@end
