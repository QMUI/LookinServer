//
//  ViewController.swift
//  LookinCustomInfoDemo
//
//  Created by likai.123 on 2023/11/2.
//

import UIKit

class ViewController: UIViewController {
    private let dogLayer = DogLayer()
    private let catView = CatView()
    private let birdView = BirdView()
    private let horseLayer = HorseLayer()
    private let viewModel0 = GoodViewModel()
    private let viewModel1 = SomeViewModel()
    
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(label)
        
        viewModel0.viewModelTargetView = catView
        viewModel1.viewModelTargetView = birdView
        
        dogLayer.backgroundColor = UIColor.blue.cgColor
        view.layer.addSublayer(dogLayer)
        dogLayer.frame = CGRect(x: 20, y: 20, width: 100, height: 100)

        catView.backgroundColor = UIColor.green
        view.addSubview(catView)
        catView.frame = CGRect(x: 20, y: 200, width: 100, height: 100)
        
        birdView.backgroundColor = UIColor.blue
        view.addSubview(birdView)
        birdView.frame = CGRect(x: 20, y: 400, width: 100, height: 100)
        
        horseLayer.backgroundColor = UIColor.orange.cgColor
        view.layer.addSublayer(horseLayer)
        horseLayer.frame = CGRect(x: 20, y: 600, width: 100, height: 100)
        
        getLookinVersion()
        
//        addManyViews()
    }

    private func getLookinVersion() {
        // NSMutableDictionary 是引用传递，而 Swift 原生字典是值传递，因此这里只能用 NSMutableDictionary
        // NSMutableDictionary is passed by reference, while Swift's native dictionary is passed by value, so here we can only use NSMutableDictionary.
        let lookinInfos = NSMutableDictionary()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetLookinInfo"), object: nil, userInfo: ["infos": lookinInfos])
        if let lookinServerVersion = lookinInfos["lookinServerVersion"] as? String {
            // 这里是小数点分割的版本号，比如"1.2.5"
            // Here is the version number separated by decimal points, such as "1.2.5"
            print("LookinServer version: \(lookinServerVersion)")
        } else {
            // 当前环境中没有集成 LookinServer，或者 LookinServer 版本低于 1.2.5
            print("No LookinServer. Or LookinServer version is lower than 1.2.5")
        }
    }
    
    private func addManyViews() {
        for i in 0..<500 {
            let v = UIView()
            v.frame = CGRect(x: 0, y: i, width: 1, height: 1)
            v.backgroundColor = UIColor.red
            view.addSubview(v)
        }
    }
}

