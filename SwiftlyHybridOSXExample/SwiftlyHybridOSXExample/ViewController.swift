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

import Cocoa
import WebKit

class ViewController: NSViewController, WKScriptMessageHandler {
    
    var appWebView:WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indexHTMLPath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.addScriptMessageHandler(self, name: "interOp")
        
        appWebView = WKWebView(frame: self.view.frame, configuration: theConfiguration)
        let url = NSURL(fileURLWithPath: indexHTMLPath!)
        let request = NSURLRequest(URL: url)
        appWebView!.loadRequest(request)
        self.view.addSubview(appWebView!)
        
        //this line of code makes the WKWebView resize when the window is resized.
        appWebView?.autoresizingMask = [NSAutoresizingMaskOptions.ViewWidthSizable, NSAutoresizingMaskOptions.ViewHeightSizable]
        
        
    }
    
    //modify this function to do any JavaScript/Swift interop communication
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        let sentData = message.body as! NSDictionary
        let aCount:Int = Int(sentData["count"] as! NSNumber)
        
        //the last parameter of evaluateJavaScript is a closure that is called after the JavaScript is run.
        //If there is a value returned from the JavaScript it is passed to the closure as its first parameter.
        //If there is an error calling the JavaScript, that error is passed as the second parameter.
        appWebView!.evaluateJavaScript("storeAndShow( \(aCount + 1) )"){(JSReturnValue:AnyObject?, error:NSError?) in
            if let errorDescription = error?.description{
                print("error: \(errorDescription)")
            }
            else if JSReturnValue != nil{
                print("returned value: \(JSReturnValue!)")
            }
            else{
                print("no return from JS")
            }
            
            
        }
    }


    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

