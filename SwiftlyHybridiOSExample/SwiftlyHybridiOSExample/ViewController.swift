//
//  ViewController.swift
//  SwiftlyHybridTemplate
//
//  Created by Lee Barney on 10/22/15.
//  Copyright © 2015 Lee Barney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var theHandler:SwiftlyMessageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theHandler = SwiftlyMessageHandler(theController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

