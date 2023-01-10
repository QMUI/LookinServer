//
//  ViewController.m
//  LookinDemoOC
//
//  Created by likai.123 on 2022/10/10.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end

@interface NSObject (Lookin)

@end

@implementation NSObject (Lookin)

- (NSArray<NSString *> *)lookin_collapsedClassList {
    return @[@"UIDropShadowView"];
}

- (NSDictionary<NSString *, UIColor *> *)lookin_colorAlias {
    return @{
        @"TitleColor": [UIColor colorWithRed:0.38 green:0.85 blue:0.22 alpha:1],
        @"MyWhite": [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
        @"MyBlack": [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
    };
}

@end
