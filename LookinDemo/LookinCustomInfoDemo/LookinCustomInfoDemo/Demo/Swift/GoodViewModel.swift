//
//  GoodViewModel.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/11.
//

import Foundation

class GoodViewModel {
    var viewModelTargetView: UIView?
    
    init() {
        NotificationCenter.default.post(name: .init("Lookin_RelationSearch"), object: self)
    }
}
