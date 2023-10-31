//
//  ViewController.m
//  LookinDemoOC
//
//  Created by likai.123 on 2022/10/10.
//

#import "ViewController.h"
#import "CatView.h"

//@interface TestView : UIImageView
//
//@end
//
//@implementation TestView
//
////- (BOOL)lookin_shouldCaptureImage {
////    return YES;
////}
//
//@end
//
//@interface TestLayer : CALayer
//
//@end
//
//@implementation TestLayer
//
////- (BOOL)lookin_shouldCaptureImage {
////    return YES;
////}
//
//@end

@interface ViewController ()

@property(nonatomic, strong) CatView *catView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tag = 1111;
    // Do any additional setup after loading the view.
    self.catView = [CatView new];
    self.catView.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.catView];
    self.catView.frame = CGRectMake(20, 20, 100, 100);
    
//    self.myLayer = [TestLayer new];
//    self.myLayer.backgroundColor = UIColor.blueColor.CGColor;
//    [self.view.layer addSublayer:self.myLayer];
//    self.myLayer.frame = CGRectMake(20, 200, 100, 100);
    
//    self.scrollView = [UIScrollView new];
//    self.scrollView.frame = CGRectMake(0, 0, 400, 800);
//    self.scrollView.contentSize = CGSizeMake(400, 1000000);
//    [self.view addSubview:self.scrollView];
//    
//    self.scrollInnerView = [UIView new];
//    [self.scrollView addSubview:self.scrollInnerView];
//    self.scrollInnerView.backgroundColor = UIColor.redColor;
//    self.scrollInnerView.frame = CGRectMake(0, 800000, 100, 100);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
//    });
}

@end

//@interface NSObject (LookinConfig)
//
//@end
//
//@implementation NSObject (LookinConfig)
//
//+ (NSArray<NSString *> *)lookin_collapsedClassList {
//    return @[@"UIDropShadowView"];
//}
//
//+ (NSDictionary<NSString *, UIColor *> *)lookin_colorAlias {
//    return @{
//        @"TitleColor": [UIColor colorWithRed:0.38 green:0.85 blue:0.22 alpha:1],
//        @"MyWhite": [UIColor colorWithRed:1 green:1 blue:1 alpha:1],
//        @"MyBlack": [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
//    };
//}
////+ (BOOL)lookin_shouldCaptureImageOfView:(UIView *)view {
////    if (view.tag == 1234) {
////        // Lookin will not show image of the view
////        return NO;
////    } else {
////        return YES;
////    }
////}
//
//+ (BOOL)lookin_shouldCaptureImageOfLayer:(CALayer *)layer {
////    if (...) {
////        // Lookin will not show image of the layer
////        return NO;
////    } else {
//        return YES;
////    }
//}
//
//@end


