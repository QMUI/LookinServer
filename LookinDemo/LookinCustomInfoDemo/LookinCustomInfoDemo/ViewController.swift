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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }


}

