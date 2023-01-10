//
//  ViewController.m
//  LookinDemoOC
//
//  Created by likai.123 on 2022/10/10.
//

#import "ViewController.h"

@interface TestView : UIImageView

@end

@implementation TestView

- (BOOL)lookin_shouldCaptureImage {
    return YES;
}

@end

@interface TestLayer : CALayer

@end

@implementation TestLayer

- (BOOL)lookin_shouldCaptureImage {
    return YES;
}

@end

@interface ViewController ()

@property(nonatomic, strong) TestView *myView;
@property(nonatomic, strong) TestLayer *myLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 1111;
    // Do any additional setup after loading the view.
    self.myView = [TestView new];
    self.myView.image = [UIImage imageNamed:@"Logo_128"];
    self.myView.tag = 1234;
    [self.view addSubview:self.myView];
    self.myView.frame = CGRectMake(20, 20, 100, 100);
    
    self.myLayer = [TestLayer new];
    self.myLayer.backgroundColor = UIColor.blueColor.CGColor;
    [self.view.layer addSublayer:self.myLayer];
    self.myLayer.frame = CGRectMake(20, 200, 100, 100);
}

@end

@interface NSObject (LookinConfig)

@end

@implementation NSObject (LookinConfig)

+ (NSArray<NSString *> *)lookin_collapsedClassList {
    return @[@"UIDropShadowView"];
}

+ (NSDictionary<NSString *, UIColor *> *)lookin_colorAlias {
    return @{
        @"TitleColor": [UIColor colorWithRed:0.38 green:0.85 blue:0.22 alpha:1],
        @"MyWhite": [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
        @"MyBlack": [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
    };
}
+ (BOOL)lookin_shouldCaptureImageOfView:(UIView *)view {
    if (view.tag == 1234) {
        // Lookin will not show image of the view
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)lookin_shouldCaptureImageOfLayer:(CALayer *)layer {
//    if (...) {
//        // Lookin will not show image of the layer
//        return NO;
//    } else {
        return YES;
//    }
}

@end


