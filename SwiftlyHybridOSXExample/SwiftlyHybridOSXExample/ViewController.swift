//
//  ViewController.swift
//  SwiftlyHybridOSXExample
//
//  Created by Lee Barney on 10/26/15.
//  Copyright © 2015 Lee Barney. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var theHandler:SwiftlyMessageHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        theHandler = SwiftlyMessageHandler(theController: self)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

