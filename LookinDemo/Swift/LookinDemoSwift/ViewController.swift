//
//  ViewController.swift
//  LookinDemoSwift
//
//  Created by likai.123 on 2022/10/10.
//

import UIKit

extension NSObject {
    @objc func lookin_shouldCaptureImageOfView(_ view: UIView) -> Bool {
        if view.tag == 1234 {
            return true
        } else {
            return true
        }
    }
    
    @objc func lookin_collapsedClassList() -> [String] {
        return ["UIDropShadowView"]
    }
    
    @objc func lookin_colorAlias() -> [String:UIColor] {
        return ["MyWhite": UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)]
    }
}

class MyView: UIView {
    @objc func lookin_shouldCaptureImage() -> Bool {
        return false
    }
}

class ViewController: UIViewController {
    private let myButton = MyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.layer.borderColor = UIColor.red.cgColor
        
//        myButton.tag = 1234
//        myButton.setTitle("abc", for: .normal)
        myButton.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        view.addSubview(myButton)
    }


}

