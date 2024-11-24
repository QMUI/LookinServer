//
//  ViewController.swift
//  AppKitDemo
//
//  Created by JH on 2024/11/5.
//

import Cocoa

class View: NSView {
    override var isFlipped: Bool { true }
}

extension NSView {
    var backgroundColor: NSColor? {
        set {
            setValue(newValue, forKeyPath: "backgroundColor")
        }
        get {
            value(forKeyPath: "backgroundColor") as? NSColor
        }
    }
}

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subview = NSView()
        subview.backgroundColor = .red
        subview.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        view.addSubview(subview)
        
        let subview2 = NSView()
        subview2.backgroundColor = .blue
        subview2.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        subview.addSubview(subview2)
        
        guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return
        }
        view.cacheDisplay(in: view.bounds, to: bitmapRep)
        let image = NSImage(size: view.bounds.size)
        image.addRepresentation(bitmapRep)
        try? image.tiffRepresentation?.write(to: .desktopDirectory.appending(path: "Test.tiff"))
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
    }
}
