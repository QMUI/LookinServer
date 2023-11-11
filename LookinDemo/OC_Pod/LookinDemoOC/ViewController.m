//
//  ViewController.m
//  LookinDemoOC
//
//  Created by likai.123 on 2022/10/10.
//

#import "ViewController.h"
#import "CatView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建 UIStackView
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical; // 设置布局方向为垂直
    stackView.alignment = UIStackViewAlignmentFill; // 设置对齐方式为居中对齐
    stackView.distribution = UIStackViewDistributionFillEqually; // 设置子视图的分布方式为均匀分布
    stackView.spacing = 10.0; // 设置子视图之间的间距为10

    // 创建子视图
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor greenColor];
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor blueColor];

    // 将子视图添加到 UIStackView 中
    [stackView addArrangedSubview:view1];
    [stackView addArrangedSubview:view2];
    [stackView addArrangedSubview:view3];

    // 将 UIStackView 添加到父视图中
    [self.view addSubview:stackView];
    
    stackView.frame = self.view.bounds;
}

@end
