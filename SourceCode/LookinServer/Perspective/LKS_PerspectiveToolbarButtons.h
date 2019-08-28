//
//  LKS_PerspectiveToolbarButtons.h
//  
//

//  
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
