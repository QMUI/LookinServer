//
//  LKS_PerspectiveHierarchyCell.h
//  LookinServer
//
//  
//  Copyright © 2019 Lookin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LookinDisplayItem;

@interface LKS_PerspectiveHierarchyCell : UITableViewCell

@property(nonatomic, strong) LookinDisplayItem *displayItem;

- (void)reRender;

@property(nonatomic, strong, readonly) UIButton *indicatorButton;

@end
