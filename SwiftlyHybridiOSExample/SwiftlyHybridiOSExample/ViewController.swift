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
    var previousOrientation: UIDeviceOrientation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add to or remove from the array the extenstions of the web files that are part of your app
        let (theWebView,errorOptional) = buildSwiftly(self, ["js","css","html","png","jpg","gif"])
        if let errorDescription = errorOptional?.description{
            println(errorDescription)
        }
        else{
            appWebView = theWebView
        }
        
        //this line of code causes the orientationChanged function to be called when the device orientationChanges.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)

    }
    //modify this function to do any JavaScript/Swift interop communication
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        let sentData = message.body as NSDictionary
        let aCount:Int = Int(sentData["count"] as NSNumber)
        
        appWebView!.evaluateJavaScript("storeAndShow( \(aCount + 1) )", completionHandler: nil)
    }
    
    
    //This function handles resizing the WKWebView's frame depending on the device orientation.
    func orientationChanged(){
        let orientation = UIDevice.currentDevice().orientation
        if previousOrientation != nil && UIDeviceOrientationIsLandscape(orientation) != UIDeviceOrientationIsLandscape(previousOrientation!)
            && orientation != UIDeviceOrientation.PortraitUpsideDown
            && orientation != UIDeviceOrientation.FaceDown
            && orientation != UIDeviceOrientation.FaceUp{
                let actualView = appWebView!
                let updatedFrame = CGRect(x: actualView.frame.origin.x, y: actualView.frame.origin.y, width: actualView.frame.size.height, height: actualView.frame.size.width)
                actualView.frame = updatedFrame
        }
        previousOrientation = orientation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

