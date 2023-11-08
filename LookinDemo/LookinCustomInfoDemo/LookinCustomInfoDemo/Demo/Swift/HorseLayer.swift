//
//  HorseLayer.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

import UIKit

class HorseLayer: CALayer {
    /// 实现该方法以在 Lookin 中展示自定义属性
    /// 请留意该方法是否已经被父类、子类、分类实现了，如果是，为了避免冲突，你可以把该方法更名为 lookin_customDebugInfos_0（末尾的数字 0 可以被替换为 0 ～ 5 中的任意数字）
    /// 每次 Lookin 刷新时都会调用该方法，因此若该方法耗时较长，则会拖慢刷新速度
    ///
    /// Implement this method to display custom properties in Lookin.
    /// Please note if this method has already been implemented by the superclass, subclass, or category. If so, to avoid conflicts, you can rename this method to lookin_customDebugInfos_0 (the trailing number 0 can be replaced with any number from 0 to 5).
    /// This method is called every time Lookin refreshes, so if this method takes a long time to execute, it will slow down the refresh speed.
    ///
    /// https://bytedance.feishu.cn/docx/TRridRXeUoErMTxs94bcnGchnlb
    @objc func lookin_customDebugInfos() -> [String:Any]? {
        let ret: [String:Any] = [
            // 可选项。这些信息会在 Lookin 的右侧属性面板中被展示。
            // Optional. These details will be displayed in the right-hand property panel of Lookin.
            "properties": self.makeCustomProperties(),
            // 可选项。这些信息会在 Lookin 左侧图层结构中被展示。
            // Optional. This information will be displayed in the layer structure on the left side of Lookin.
            "subviews": self.makeCustomSubviews()
        ]
        return ret
    }
    
    private func makeCustomProperties() -> [Any] {
        // string property
        var stringProperty: [String:Any] = [
            /// 可选项。 在 Lookin 中展示的属性组的名称。
            /// Optional. The name of the property group displayed in Lookin.
            "section": "HorseInfo",
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
        ///【警告】这个 block 会被 Lookin 始终持有，因此请万分注意内存管理。
        /// Optional. If this field is configured, users can modify the property by Lookin.
        /// [Warning] This block will be retained by Lookin indefinitely, so please be extremely careful with memory management.
        let stringSetter: @convention(block)(String?) -> Void = { newString in
            print("Try to modify by Lookin. \(String(describing: newString))")
        }
        stringProperty["retainedSetter"] = unsafeBitCast(stringSetter, to: AnyObject.self)
        
        
        // number property
        var numberProperty: [String:Any] = [
            "section": "HorseInfo",
            "title": "Age",
            "value": 4.53,
            "valueType": "number"
        ]
        let numberSetter: @convention(block)(NSNumber) -> Void = { newNumber in
            print("Try to modify by Lookin. \(newNumber.doubleValue)")
        }
        numberProperty["retainedSetter"] = unsafeBitCast(numberSetter, to: AnyObject.self)
        
        
        // bool property
        var boolProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "IsFriendly",
            "value": false,
            "valueType": "bool"
        ]
        let boolSetter: @convention(block)(Bool) -> Void = { newBool in
            print("Try to modify by Lookin. \(newBool)")
        }
        boolProperty["retainedSetter"] = unsafeBitCast(boolSetter, to: AnyObject.self)
        
        
        // color property
        var colorProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "SkinColor",
            "value": UIColor.green,
            "valueType": "color"
        ]
        let colorSetter: @convention(block)(UIColor?) -> Void = { newColor in
            print("Try to modify by Lookin. \(String(describing: newColor))")
        }
        colorProperty["retainedSetter"] = unsafeBitCast(colorSetter, to: AnyObject.self)
        
        
        // enum property
        var enumProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "Gender",
            "value": "Female",
            "valueType": "enum",
            // 当 valueType 为 enum 时，必须设置该项，内容为所有可用的 enum 值。
            // When valueType is "enum", this item must be set, with the content being all available enum cases.
            "allEnumCases": ["Male", "Female"]
        ]
        let enumSetter: @convention(block)(String) -> Void = { newValue in
            print("Try to modify by Lookin. \(newValue)")
        }
        enumProperty["retainedSetter"] = unsafeBitCast(enumSetter, to: AnyObject.self)
        
        return [stringProperty, numberProperty, boolProperty, colorProperty, enumProperty]
    }
    
    func makeCustomSubviews() -> [Any] {
        let subview0: [String:Any] = [
            // 必填项。该元素在 Lookin 中展示的名字。
            // Required. The name of the element displayed in Lookin.
            "title": "Fake Horse Subview",
            // 可选项。该元素在 Lookin 中展示的副标题。
            // Optional. The subtitle of the element displayed in Lookin.
            "subtitle": "GoodMorning",
            // 可选项。如果包含该项目，则 Lookin 会在中间图像区域展示一个线框。这里的 Rect 是相对于当前 Window 的（不是相对于父元素）。
            // Optional. If this item is included, Lookin will display a wireframe in the middle image area. The Rect here is relative to the current Window (not relative to the parent element).
            "frameInWindow": NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 300, height: 500)),
            // 可选项。这些信息会展示在 Lookin 的右侧面板，字段格式参见上面的 makeCustomProperties 方法
            // Optional. This information will be displayed in the right-hand panel of Lookin, with field formatting as described in the makeCustomProperties method above.
            "properties": [
                ["section":"Animal Info", "title":"Name", "value":"Mary", "valueType":"string"],
                ["section":"Animal Info", "title":"Age", "value":3.2, "valueType":"number"]
            ]
        ]
        
        let subview1: [String:Any] = [
            "title": "Horse ViewModel",
            // 可选项。你可以递归地添加你的虚拟 subview。
            // Optional. You can recursively add your virtual subview.
            "subviews": [
                ["title": "ViewModel1"],
                ["title": "ViewModel2"]
            ]
        ]
        
        return [subview0, subview1]
    }
}
