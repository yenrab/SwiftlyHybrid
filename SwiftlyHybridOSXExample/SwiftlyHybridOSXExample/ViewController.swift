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

