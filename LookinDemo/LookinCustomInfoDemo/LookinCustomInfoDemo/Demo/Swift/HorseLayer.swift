//
//  HorseLayer.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

import UIKit

class HorseLayer: CALayer {
    @objc func lookin_customDebugInfos() -> [String:Any]? {
        let ret: [String:Any] = [
            "properties": self.makeCustomProperties(),
            "subviews": self.makeCustomSubviews()
        ]
        return ret
    }
    
    private func makeCustomProperties() -> [Any] {
        let stringProperty: [String:Any] = [
            "section": "HorseInfo",
            "title": "Nickname",
            "value": "LiKai",
            "valueType": "string"
        ]
        
        let numberProperty: [String:Any] = [
            "section": "HorseInfo",
            "title": "Age",
            "value": 10,
            "valueType": "number"
        ]
        
        let boolProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "IsFriendly",
            "value": true,
            "valueType": "bool"
        ]
        
        let colorProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "SkinColor",
            "value": UIColor.black,
            "valueType": "color"
        ]
        
        let enumProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "Gender",
            "value": "Female",
            "valueType": "enum",
            // Set object for this key when the valueType is "enum".
            "allEnumCases": ["Male", "Female"]
        ]
        
        return [stringProperty, numberProperty, boolProperty, colorProperty, enumProperty]
    }
    
    func makeCustomSubviews() -> [Any] {
        let subview0: [String:Any] = [
            "title": "StrongHorse",
            // Optional
            // 可选
            "subtitle": "GoodMorning",
            "frameInWindow": NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 300, height: 500)),
            "properties": [
                ["section":"Animal Info", "title":"Name", "value":"Mary", "valueType":"string"],
                ["section":"Animal Info", "title":"Age", "value":3.2, "valueType":"number"]
            ]
        ]
        
        let subview1: [String:Any] = [
            "title": "WeakHorse",
            "subviews": [
                ["title": "WeakHorseSon"],
                ["title": "WeakHorseDaughter"]
            ]
        ]
        
        return [subview0, subview1]
    }
}
