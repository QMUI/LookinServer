//
//  CatView.m
//  LookinDemoOC
//
//  Created by likai.123 on 2023/10/16.
//

#import "CatView.h"
#import <UIKit/UIKit.h>

@implementation CatView

- (NSDictionary<NSString *, id> *)lookin_customDebugInfos {
    NSDictionary<NSString *, id> *ret = @{
        // Optional. You can set object for this key to display your custom debug infos in the right panel of Lookin.
        // 可选。你可以配置该字段从而在 Lookin 的右侧面板展示你的自定义调试信息。
        @"properties": [self makeCustomProperties],
        
        // Optional. You can set object for this key to display your custom subviews in the left panel of Lookin.
        // 可选。你可以配置该字段从而在 Lookin 的左侧面板展示你的自定义 subview 对象。
        @"subviews": [self makeCustomSubviews]
    };
    return ret;
}

- (NSArray *)makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    // string property
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Nickname",
        @"value": @"British shorthair",
        @"valueType": @"string"
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
        @"section": @"CatInfo",
        @"title": @"IsFriendly",
        @"value": @YES,
        @"valueType": @"bool"
    }];
    
    // color property
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"SkinColor",
        @"value": [UIColor redColor],
        @"valueType": @"color"
    }];
    
    // enum property
    [properties addObject:@{
        @"section": @"CatInfo",
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
