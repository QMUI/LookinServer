//
//  CALayer+Custom.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

import UIKit

extension CALayer {
    @objc func lookin_customDebugInfos_1() -> [String:Any]? {
        let ret: [String:Any] = [
            "properties": self.makeCustomProperties()
        ]
        return ret
    }
    
    private func makeCustomProperties() -> [Any] {
        let stringProperty: [String:Any] = [
            "section": "Life Style",
            "title": "Hobby",
            "value": "Bike",
            "valueType": "string"
        ]
        
        return [stringProperty]
    }
}
