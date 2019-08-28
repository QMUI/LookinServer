//
//  LKS_PerspectiveHierarchyView.h
//  LookinServer
//
//  
//  Copyright © 2019 Lookin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKS_PerspectiveDataSource.h"

@interface LKS_PerspectiveHierarchyView : UIView <LKS_PerspectiveDataSourceDelegate>

- (instancetype)initWithDataSource:(LKS_PerspectiveDataSource *)dataSource;

@property(nonatomic, assign) BOOL isHorizontalLayout;

@end
