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
        @"properties": [self makeCustomProperties],
        @"subviews": [self makeCustomSubviews]
    };
    return ret;
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
        // Optional. These infos will be displayed in the right panel of Lookin.
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
        // 可选。你可以递归地、无限地添加你的虚拟 subview。
        @"subviews": @[
            @{ @"title": @"CatBabyBaby" },
            @{ @"title": @"CatBabyBaby" }
        ]
    }];
    
    return [subviews copy];
}

- (NSArray *)makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    // string
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Nickname",
        @"value": @"British shorthair",
        @"valueType": @"string",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSString class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // number
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Age",
        @"value": @13.2,
        @"valueType": @"number",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // bool
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"IsFriendly",
        @"value": @YES,
        @"valueType": @"bool",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSNumber class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // color
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"SkinColor",
        @"value": [UIColor redColor],
        @"valueType": @"color",
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[UIColor class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    // enum
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Gender",
        @"value": @"Male",
        @"valueType": @"enum",
        // Set object for this key when the valueType is "enum".
        @"allEnumCases": @[@"Male", @"Female"],
        // Optional. Set this key to allow user to modify the property value in Lookin.
        @"setter": ^(id newValue){
            if (![newValue isKindOfClass:[NSString class]]) {
                return;
            }
            NSLog(@"Get new value from lookin: %@", newValue);
        }
    }];
    
    return [properties copy];;
}


@end
