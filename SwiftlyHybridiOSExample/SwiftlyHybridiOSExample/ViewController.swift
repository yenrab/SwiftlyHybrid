//
//  ViewController.swift
//  SwiftlyHybridiOSExample
//
//  Created by Lee Barney on 10/29/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKScriptMessageHandler {

    var appWebView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add to or remove from the array the extenstions of the web files that are part of your app
        let (theWebView,errorOptional) = buildSwiftly(self, ["js","css","html","png","jpg","gif"], ["subDir"])
        if let errorDescription = errorOptional?.description{
            println(errorDescription)
        }
        else{
            println(theWebView)
            appWebView = theWebView
        }

    }
    //modify this function to do any JavaScript/Swift interop communication
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        let sentData = message.body as NSDictionary
        let aCount:Int = Int(sentData["count"] as NSNumber)
        
        appWebView!.evaluateJavaScript("storeAndShow( \(aCount + 1) )", completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

