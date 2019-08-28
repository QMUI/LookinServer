//
//  LKS_LocalInspectPanelLabelView.h
//  LookinServer
//

//  Copyright © 2019 hughkli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKS_LocalInspectPanelLabelView : UIView

@property(nonatomic, strong) UILabel *leftLabel;
@property(nonatomic, strong) UILabel *rightLabel;
@property(nonatomic, assign) CGFloat verInset;
@property(nonatomic, assign) CGFloat interspace;
@property(nonatomic, strong) CALayer *bottomBorderLayer;

- (void)addBottomBorderLayer;

@end
