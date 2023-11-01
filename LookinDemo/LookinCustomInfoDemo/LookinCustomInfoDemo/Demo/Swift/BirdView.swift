//
//  BirdView.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

import UIKit

class BirdView: UIView {
    @objc func lookin_customDebugInfos() -> [String:Any]? {
        let ret: [String:Any] = [
            "properties": self.makeCustomProperties()
        ]
        return ret
    }
    
    func makeCustomProperties() -> [Any] {
        let stringProperty: [String:Any] = [
            "section": "BirdInfo",
            "title": "Nickname",
            "value": "Jerry",
            "valueType": "string"
        ]
        
        let numberProperty: [String:Any] = [
            "section": "BirdInfo",
            "title": "Age",
            "value": 4.53,
            "valueType": "number"
        ]
        
        let boolProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "IsFriendly",
            "value": false,
            "valueType": "bool"
        ]
        
        let colorProperty: [String:Any] = [
            "section": "Animal Info",
            "title": "SkinColor",
            "value": UIColor.green,
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
}
