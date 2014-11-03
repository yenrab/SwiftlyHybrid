//
//  ViewController.swift
//  SwiftlyHybridOSXExample
//
//  Created by Lee Barney on 11/3/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKScriptMessageHandler {
    
    var appWebView:WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add to or remove from the array the extenstions of the web files that are part of your app
        let (theWebView,errorOptional) = buildSwiftly(self, ["js","css","html","png","jpg","gif"])
        if let errorDescription = errorOptional?.description{
            println(errorDescription)
        }
        else{
            appWebView = theWebView
            //this line of code makes the WKWebView resize when the window is resized.
            appWebView?.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable
        }
        
    }
    
    //modify this function to do any JavaScript/Swift interop communication
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        let sentData = message.body as NSDictionary
        let aCount:Int = Int(sentData["count"] as NSNumber)
        
        appWebView!.evaluateJavaScript("storeAndShow( \(aCount + 1) )", completionHandler: nil)
    }


    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

