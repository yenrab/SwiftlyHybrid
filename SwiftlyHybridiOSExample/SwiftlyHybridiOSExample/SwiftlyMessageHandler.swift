/*
The MIT License (MIT)

Copyright (c) 2015 Lee Barney

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

import WebKit

class SwiftlyMessageHandler:NSObject, WKScriptMessageHandler {
    var appWebView:WKWebView?
    
    init(theController:ViewController){
        super.init()
        let theConfiguration = WKWebViewConfiguration()
    
        theConfiguration.userContentController.add(self, name: "native")
        
        
        let indexHTMLPath = Bundle.main.path(forResource: "index", ofType: "html")
        appWebView = WKWebView(frame: theController.view.frame, configuration: theConfiguration)
        let url = URL(fileURLWithPath: indexHTMLPath!)
        let request = URLRequest.init(url: url)
        appWebView!.load(request)
        theController.view.addSubview(appWebView!)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let sentData = message.body as! NSDictionary
        
        let command = sentData["cmd"] as! String
        var response = Dictionary<String,AnyObject>()
        if command == "increment"{
            guard var count = sentData["count"] as? Int else{
                return
            }
            count += 1
            response["count"] = count as AnyObject
        }
        let callbackString = sentData["callbackFunc"] as? String
        sendResponse(aResponse: response, callback: callbackString)
    }
    func sendResponse(aResponse:Dictionary<String,AnyObject>, callback:String?){
        guard let callbackString = callback else{
            return
        }
        guard let generatedJSONData = try? JSONSerialization.data(withJSONObject: aResponse, options: JSONSerialization.WritingOptions(rawValue: 0)) else{
            print("failed to generate JSON for \(aResponse)")
            return
        }
        
        appWebView!.evaluateJavaScript("(\(callbackString)('\(NSString(data:generatedJSONData, encoding:String.Encoding.utf8.rawValue)!)'))") {(JSReturnValue, error) in
            if let errorDescription = (error as NSError?)?.description{
                print("returned value: \(errorDescription)")
            }
            else if JSReturnValue != nil{
                print("returned value: \(JSReturnValue!)")
            }
            else{
                print("no return from JS")
            }
        }
       
    }

}
