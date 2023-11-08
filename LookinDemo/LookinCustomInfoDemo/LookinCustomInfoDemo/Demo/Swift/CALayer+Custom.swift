//
//  CALayer+Custom.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

import UIKit

extension CALayer {
    /// 实现该方法以在 Lookin 中展示自定义属性
    /// 请留意该方法是否已经被父类、子类、分类实现了，如果是，为了避免冲突，你可以把该方法更名为 lookin_customDebugInfos_0（末尾的数字 0 可以被替换为 0 ～ 5 中的任意数字）
    /// 每次 Lookin 刷新时都会调用该方法，因此若该方法耗时较长，则会拖慢刷新速度
    ///
    /// Implement this method to display custom properties in Lookin.
    /// Please note if this method has already been implemented by the superclass, subclass, or category. If so, to avoid conflicts, you can rename this method to lookin_customDebugInfos_0 (the trailing number 0 can be replaced with any number from 0 to 5).
    /// This method is called every time Lookin refreshes, so if this method takes a long time to execute, it will slow down the refresh speed.
    ///
    /// https://bytedance.feishu.cn/docx/TRridRXeUoErMTxs94bcnGchnlb
    @objc func lookin_customDebugInfos_1() -> [String:Any]? {
        let ret: [String:Any] = [
            "properties": self.cusotm_makeCustomProperties()
        ]
        return ret
    }
    
    private func cusotm_makeCustomProperties() -> [Any] {
        let stringProperty: [String:Any] = [
            "section": "Life Style",
            "title": "Hobby",
            "value": "Bike",
            "valueType": "string"
        ]
        
        return [stringProperty]
    }
}
