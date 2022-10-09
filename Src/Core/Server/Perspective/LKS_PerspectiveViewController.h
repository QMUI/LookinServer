//
//  LKS_PerspectiveViewController.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//



#import <UIKit/UIKit.h>

@class LookinHierarchyInfo, LKS_PerspectiveToolbarCloseButton;

@interface LKS_PerspectiveViewController : UIViewController

- (instancetype)initWithHierarchyInfo:(LookinHierarchyInfo *)info;

@property(nonatomic, strong, readonly) LKS_PerspectiveToolbarCloseButton *closeButton;

@end
