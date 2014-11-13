/*
Copyright (c) 2014 Lee Barney
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.


THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


*/

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
        
        //the last parameter of evaluateJavaScript is a closure that is called after the JavaScript is run.
        //If there is a value returned from the JavaScript it is passed to the closure as its first parameter.
        //If there is an error calling the JavaScript, that error is passed as the second parameter.
        appWebView!.evaluateJavaScript("storeAndShow( \(aCount + 1) )"){(JSReturnValue:AnyObject?, error:NSError?) in
            if let errorDescription = error?.description{
                println("returned value: \(errorDescription)")
            }
            else if JSReturnValue != nil{
                println("returned value: \(JSReturnValue!)")
            }
            else{
                println("no return from JS")
            }
        }
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

