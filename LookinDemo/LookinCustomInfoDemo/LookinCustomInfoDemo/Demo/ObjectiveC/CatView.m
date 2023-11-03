//
//  CatView.m
//  LookinDemoOC
//
//  Created by likai.123 on 2023/10/16.
//

#import "CatView.h"
#import <UIKit/UIKit.h>

@implementation CatView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Tom";
    }
    return self;
}

- (NSDictionary<NSString *, id> *)lookin_customDebugInfos {
    NSDictionary<NSString *, id> *ret = @{
        @"properties": [self makeCustomProperties],
        @"subviews": [self makeCustomSubviews]
    };
    return ret;
}

- (NSArray *)makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    __weak __typeof__(self) weakSelf = self;
    // string property
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Nickname",
        @"value": self.name,//@"British shorthair",
        @"valueType": @"string",
        @"retainedSetter": ^(NSString *newString) {
            weakSelf.name = newString;
        }
    }];
    
    // number property
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Age",
        @"value": @13.2,
        @"valueType": @"number"
    }];
    
    // bool property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"IsFriendly",
        @"value": @NO,
        @"valueType": @"bool"
    }];
    
    // color property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"SkinColor",
        @"value": [UIColor redColor],
        @"valueType": @"color"
    }];
    
    // enum property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"Gender",
        @"value": @"Male",
        @"valueType": @"enum",
        // Set object for this key when the valueType is "enum".
        @"allEnumCases": @[@"Male", @"Female"]
    }];
    
    return [properties copy];;
}

- (NSArray *)makeCustomSubviews {
    NSMutableArray *subviews = [NSMutableArray array];
    
    [subviews addObject:@{
        @"title": @"CatBaby0",
        // Optional
        // 可选
        @"subtitle": @"Nice Baby",
        // Optional. If you set object for this key, there will be a wireframe in Lookin middle area. The rect is in UIWindow coordinate (not superview coordinate).
        // 可选。如果包含该 key，则 Lookin 中间会为该 subview 展示一个线框。这里的 Rect 是相对于当前 Window 的（不是相对于父元素）
        @"frameInWindow": [NSValue valueWithCGRect:CGRectMake(100, 100, 200, 300)],
        // Optional. Your custom debug infos in the right panel of Lookin.
        // 可选。这些信息会展示在 Lookin 的右侧面板。
        @"properties": @[
            @{
                @"section": @"CatInfo",
                @"title": @"Nickname",
                @"value": @"Tom",
                @"valueType": @"string",
            },
            @{
                @"section": @"CatInfo",
                @"title": @"Age",
                @"value": @8,
                @"valueType": @"number",
            },
        ]
    }];

    [subviews addObject:@{
        @"title": @"CatBaby1",
        // Optional. You can add custom subviews recursively.
        // 可选。你可以递归地添加你的虚拟 subview。
        @"subviews": @[
            @{ @"title": @"CatBabyBaby" },
            @{ @"title": @"CatBabyBaby" }
        ]
    }];
    
    return [subviews copy];
}

@end
