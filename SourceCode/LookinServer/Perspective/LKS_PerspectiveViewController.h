//
//  LKS_PerspectiveViewController.h
//  LookinServer
//

//  Copyright © 2019 hughkli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LookinHierarchyInfo, LKS_PerspectiveToolbarCloseButton;

@interface LKS_PerspectiveViewController : UIViewController

- (instancetype)initWithHierarchyInfo:(LookinHierarchyInfo *)info;

@property(nonatomic, strong, readonly) LKS_PerspectiveToolbarCloseButton *closeButton;

@end
