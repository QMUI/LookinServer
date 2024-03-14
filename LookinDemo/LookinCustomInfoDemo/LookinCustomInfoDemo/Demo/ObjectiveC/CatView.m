//
//  CatView.m
//  LookinDemoOC
//
//  Created by likai.123 on 2023/10/16.
//

#import "CatView.h"
#import <UIKit/UIKit.h>

@interface CatView ()

@end

@implementation CatView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

/// 实现该方法以在 Lookin 中展示自定义属性
/// 请留意该方法是否已经被父类、子类、分类实现了，如果是，为了避免冲突，你可以把该方法更名为 lookin_customDebugInfos_0（末尾的数字 0 可以被替换为 0 ～ 5 中的任意数字）
/// 每次 Lookin 刷新时都会调用该方法，因此若该方法耗时较长，则会拖慢刷新速度
///
/// Implement this method to display custom properties in Lookin.
/// Please note if this method has already been implemented by the superclass, subclass, or category. If so, to avoid conflicts, you can rename this method to lookin_customDebugInfos_0 (the trailing number 0 can be replaced with any number from 0 to 5).
/// This method is called every time Lookin refreshes, so if this method takes a long time to execute, it will slow down the refresh speed.
///
/// https://bytedance.feishu.cn/docx/TRridRXeUoErMTxs94bcnGchnlb
- (NSDictionary<NSString *, id> *)lookin_customDebugInfos {
    NSDictionary<NSString *, id> *ret = @{
        // 可选项。这些信息会在 Lookin 的右侧属性面板中被展示。
        // Optional. These details will be displayed in the right-hand property panel of Lookin.
        @"properties": [self catView_makeCustomProperties],
        // 可选项。这些信息会在 Lookin 左侧图层结构中被展示。
        // Optional. This information will be displayed in the layer structure on the left side of Lookin.
        @"subviews": [self catView_makeCustomSubviews],
        // 可选项。该 View 实例在 Lookin 左侧图层树中的名字。
        // Optional. The name of the view instance in the hierarchy panel on the left side of Lookin.
        @"title": @"CustomCatView",
        // 可选项。为 DanceUI 项目组预留的字段，项目组之外的人请忽略
        // Optional. Reserved fields for the DanceUI project team, please ignore if you are not part of the team.
        @"lookin_source": [self createDanceUIJson],
    };
    return ret;
}

- (NSArray *)catView_makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    // 更多类型示例参加 DogLayer.m
    // See DogLayer.m for more examples
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Age",
        @"value": [NSNumber numberWithDouble:8],
        @"valueType": @"number",
        @"retainedSetter": ^(NSNumber *newNumber) {
            NSLog(@"Try to modify by Lookin.");
        }
    }];
    
    return [properties copy];
}

- (NSArray *)catView_makeCustomSubviews {
    NSMutableArray *subviews = [NSMutableArray array];
    
    [subviews addObject:@{
        // 必填项。该元素在 Lookin 中展示的名字。
        // Required. The name of the element displayed in Lookin.
        @"title": @"Fake Cat Subview",
        // 可选项。该元素在 Lookin 中展示的副标题。
        // Optional. The subtitle of the element displayed in Lookin.
        @"subtitle": @"Nice Baby",
        // 可选项。如果包含该项目，则 Lookin 会在中间图像区域展示一个线框。这里的 Rect 是相对于当前 Window 的（不是相对于父元素）。
        // Optional. If this item is included, Lookin will display a wireframe in the middle image area. The Rect here is relative to the current Window (not relative to the parent element).
        @"frameInWindow": [NSValue valueWithCGRect:CGRectMake(100, 100, 200, 300)],
        // 可选项。这些信息会展示在 Lookin 的右侧面板，字段格式参见上面的 catView_makeCustomProperties 方法
        // Optional. This information will be displayed in the right-hand panel of Lookin, with field formatting as described in the catView_makeCustomProperties method above.
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
        @"title": @"SomeConfig",
        // 可选项。为 DanceUI 项目组预留的字段，项目组之外的人请忽略
        // Optional. Reserved fields for the DanceUI project team, please ignore if you are not part of the team.
        @"lookin_source": [self createDanceUIJson],
        // 可选项。你可以递归地添加你的虚拟 subview。
        // Optional. You can recursively add your virtual subview.
        @"subviews": @[
            @{ @"title": @"CatConfig0" },
            @{ @"title": @"CatConfig1" }
        ]
    }];
    
    return [subviews copy];
}

- (NSString *)createDanceUIJson {
    NSDictionary *dict = @{
        @"type": @"DanceUIApp.ContentView",
        @"method": @"body.get",
        @"build_path": @"/Users/bytedance/Library/Developer/Xcode/DerivedData/DanceUIApp-ayaxbucdgzeouqefaavnvvhsjpvj/Build/Products/Debug-iphonesimulator/DanceUIApp.app/DanceUIApp"
    };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
