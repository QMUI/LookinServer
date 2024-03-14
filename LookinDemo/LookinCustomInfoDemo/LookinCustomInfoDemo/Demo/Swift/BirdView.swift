//
//  BirdView.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

import UIKit

class BirdView: UIView {
    /// 实现该方法以在 Lookin 中展示自定义属性
    /// 请留意该方法是否已经被父类、子类、分类实现了，如果是，为了避免冲突，你可以把该方法更名为 lookin_customDebugInfos_0（末尾的数字 0 可以被替换为 0 ～ 5 中的任意数字）
    /// 每次 Lookin 刷新时都会调用该方法，因此若该方法耗时较长，则会拖慢刷新速度
    ///
    /// Implement this method to display custom properties in Lookin.
    /// Please note if this method has already been implemented by the superclass, subclass, or category. If so, to avoid conflicts, you can rename this method to lookin_customDebugInfos_0 (the trailing number 0 can be replaced with any number from 0 to 5).
    /// This method is called every time Lookin refreshes, so if this method takes a long time to execute, it will slow down the refresh speed.
    ///
    /// https://bytedance.feishu.cn/docx/TRridRXeUoErMTxs94bcnGchnlb
    @objc func lookin_customDebugInfos() -> [String: Any]? {
        let ret: [String: Any] = [
            "properties": makeCustomProperties(),
        ]
        return ret
    }

    func makeCustomProperties() -> [Any] {
        // string property
        var stringProperty: [String: Any] = [
            /// 可选项。 在 Lookin 中展示的属性组的名称。
            /// Optional. The name of the property group displayed in Lookin.
            "section": "BirdInfo",
            /// 必填项。在 Lookin 中展示的属性的名称。
            /// Required. The name of the property displayed in Lookin.
            "title": "Nickname",
            /// 可选项。在 Lookin 中展示的属性的值。如果属性值为 nil 则不要设置该项，否则 NSDictionary 可能由于插入 nil 而 Crash。
            /// Optional. The value of the property displayed in Lookin. If the property value is nil, do not set this item, otherwise Dictionary may crash due to inserting nil.
            "value": "Jerry",
            /// 必填项。告知 Lookin 以 String 格式解析和展示该属性。
            /// Required. Specify the format in which Lookin should parse and display the property.
            "valueType": "string",
        ]
        /// 可选项。如果配置了该字段，则用户可以在 Lookin 中实时修改该属性。
        /// 【警告】这个 block 会被 Lookin 始终持有，因此请万分注意内存管理。
        /// Optional. If this field is configured, users can modify the property by Lookin.
        /// [Warning] This block will be retained by Lookin indefinitely, so please be extremely careful with memory management.
        let stringSetter: @convention(block) (String?) -> Void = { newString in
            print("Try to modify by Lookin. \(String(describing: newString))")
        }
        stringProperty["retainedSetter"] = unsafeBitCast(stringSetter, to: AnyObject.self)

        // number property
        var numberProperty: [String: Any] = [
            "section": "BirdInfo",
            "title": "Age",
            "value": 4.53,
            "valueType": "number",
        ]
        let numberSetter: @convention(block) (NSNumber) -> Void = { newNumber in
            print("Try to modify by Lookin. \(newNumber.doubleValue)")
        }
        numberProperty["retainedSetter"] = unsafeBitCast(numberSetter, to: AnyObject.self)

        // bool property
        var boolProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "IsFriendly",
            "value": false,
            "valueType": "bool",
        ]
        let boolSetter: @convention(block) (Bool) -> Void = { newBool in
            print("Try to modify by Lookin. \(newBool)")
        }
        boolProperty["retainedSetter"] = unsafeBitCast(boolSetter, to: AnyObject.self)

        // color property
        var colorProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "SkinColor",
            "value": UIColor.green,
            "valueType": "color",
        ]
        let colorSetter: @convention(block) (UIColor?) -> Void = { newColor in
            print("Try to modify by Lookin. \(String(describing: newColor))")
        }
        colorProperty["retainedSetter"] = unsafeBitCast(colorSetter, to: AnyObject.self)

        // rect property
        var rectProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "SkinRect",
            "value": CGRect(x: 1, y: 2, width: 3, height: 4),
            "valueType": "rect",
        ]
        let rectSetter: @convention(block) (CGRect) -> Void = { newRect in
            print("Try to modify by Lookin. \(String(describing: newRect))")
        }
        rectProperty["retainedSetter"] = unsafeBitCast(rectSetter, to: AnyObject.self)

        // size property
        var sizeProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "SkinSize",
            "value": CGSize(width: 4, height: 5),
            "valueType": "size",
        ]
        let sizeSetter: @convention(block) (CGSize) -> Void = { newSize in
            print("Try to modify by Lookin. \(String(describing: newSize))")
        }
        sizeProperty["retainedSetter"] = unsafeBitCast(sizeSetter, to: AnyObject.self)

        // point property
        var pointProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "SkinPoint",
            "value": CGPoint(x: 6, y: 7),
            "valueType": "point",
        ]
        let pointSetter: @convention(block) (CGPoint) -> Void = { newPoint in
            print("Try to modify by Lookin. \(String(describing: newPoint))")
        }
        pointProperty["retainedSetter"] = unsafeBitCast(pointSetter, to: AnyObject.self)

        // shadow property
        let shadowProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "SkinShadow",
            "value": [
                "opacity": 0.5,
                "offset": CGSize(width: 5, height: 10),
                "radius": 2.5,
                // 可选项，没有该项则表示颜色为 nil
                // Optional. Do not set this item when the shadow color is nil.
                "color": UIColor.red,
            ],
            "valueType": "shadow",
        ]

        // enum property
        var enumProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "Gender",
            "value": "Female",
            "valueType": "enum",
            // 当 valueType 为 enum 时，必须设置该项，内容为所有可用的 enum 值。
            // When valueType is "enum", this item must be set, with the content being all available enum cases.
            "allEnumCases": ["Male", "Female"],
        ]
        let enumSetter: @convention(block) (String) -> Void = { newValue in
            print("Try to modify by Lookin. \(newValue)")
        }
        enumProperty["retainedSetter"] = unsafeBitCast(enumSetter, to: AnyObject.self)

        // json property
        let jsonProperty: [String: Any] = [
            "section": "Animal Info",
            "title": "SkinJson",
            "value": createSomeJson(),
            "valueType": "json",
        ]

        return [stringProperty, numberProperty, boolProperty, colorProperty, rectProperty, sizeProperty, pointProperty, shadowProperty, enumProperty, jsonProperty]
    }

    /*
     JSON 的结构要求：只能有 “title”、“desc”、“details” 3 种 Key，“title”和“desc”的值必须是字符串，“details”的值必须是数组。
     
     The structure requirements of JSON are as follows. There are only three types of keys: "title", "desc", and "details". The value of "title" and "desc" must be a string, and the value of "details" must be an array.
     */
    private func createSomeJson() -> String {
        let array = [
            [
                "title": "allowedBehaviors",
                "desc": "HostingControllerAllowedBehaviors",
                "details": [
                    [
                        "title": "rawValue",
                        "desc": "0",
                    ], [
                        "title": "contentScrollViewBridge",
                        "desc": "UIKitContentScrollViewBridge",
                        "details": [
                            [
                                "title": "bridgeSetEdges",
                                "desc": "[:]",
                            ], [
                                "title": "pixelLength",
                                "desc": "0.33333333",
                            ]],
                    ]],
            ],
            [
                "title": "scenePhase",
                "desc": "active",
            ],
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: array, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString!
    }
}
