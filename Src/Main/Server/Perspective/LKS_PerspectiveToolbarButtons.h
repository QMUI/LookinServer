#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_PerspectiveToolbarButtons.h
//  qmuidemo
//
//  Created by Li Kai on 2018/12/20.
//  Copyright © 2018 QMUI Team. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface LKS_PerspectiveToolbarCloseButton : UIButton

@end

@interface LKS_PerspectiveToolbarDimensionButtonsView : UIView

@property(nonatomic, strong, readonly) UIButton *button2D;
@property(nonatomic, strong, readonly) UIButton *button3D;

@end

@interface LKS_PerspectiveToolbarLayoutButtonsView : UIView

@property(nonatomic, strong, readonly) UIButton *verticalLayoutButton;
@property(nonatomic, strong, readonly) UIButton *horizontalLayoutButton;

@end

@interface LKS_PerspectiveToolbarPropertyButton : UIButton

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
