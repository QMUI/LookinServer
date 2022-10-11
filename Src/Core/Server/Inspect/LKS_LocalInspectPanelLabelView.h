#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_LocalInspectPanelLabelView.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/15.
//  https://lookin.work
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

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
