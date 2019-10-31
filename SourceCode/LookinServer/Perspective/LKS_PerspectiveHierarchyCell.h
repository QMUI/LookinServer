//
//  LKS_PerspectiveHierarchyCell.h
//  LookinServer
//
//  Created by Li Kai on 2018/12/24.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <UIKit/UIKit.h>

@class LookinDisplayItem;

@interface LKS_PerspectiveHierarchyCell : UITableViewCell

@property(nonatomic, strong) LookinDisplayItem *displayItem;

- (void)reRender;

@property(nonatomic, strong, readonly) UIButton *indicatorButton;

@end

#endif
