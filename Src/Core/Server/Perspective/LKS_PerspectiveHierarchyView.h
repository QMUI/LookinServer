//
//  LKS_PerspectiveHierarchyView.h
//  LookinServer
//
//  Created by Li Kai on 2018/12/24.
//  https://lookin.work
//



#import <UIKit/UIKit.h>
#import "LKS_PerspectiveDataSource.h"

@interface LKS_PerspectiveHierarchyView : UIView <LKS_PerspectiveDataSourceDelegate>

- (instancetype)initWithDataSource:(LKS_PerspectiveDataSource *)dataSource;

@property(nonatomic, assign) BOOL isHorizontalLayout;

@end
