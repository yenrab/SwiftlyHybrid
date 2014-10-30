//
//  SwiftlyHybrid.swift
//  Swift Hybrid 2
//
//  Created by Lee Barney on 10/29/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

import Foundation
import WebKit

struct SwiftlyHybridError {
    var description:String?
}
/*
    // for OSX
func buildSwiftly(theViewController:NSViewController, webFileTypesInApp:[String]?, webDirectoriesInApp:[String]?) ->(WKWebView?,SwiftlyHybridError?){
*/
// for iOS
func buildSwiftly(theViewController:UIViewController, webFileTypesInApp:[String]?, webDirectoriesInApp:[String]?) ->(WKWebView?,SwiftlyHybridError?){
    var creationError:SwiftlyHybridError?
    var webView:WKWebView?
    
    var indexHTMLPath:String?
    if let messageHandler = theViewController as? WKScriptMessageHandler{
        if webFileTypesInApp != nil{
            let (foundIndexPath,moveError) = moveWebFiles(webFileTypesInApp!)
            if (moveError != nil){
                creationError = SwiftlyHybridError(description: moveError!)
            }
            else{
                indexHTMLPath = foundIndexPath
            }
        }
        if webFileTypesInApp != nil{
            let (foundIndexPath,moveError) = moveDirectories(webDirectoriesInApp!)
            if indexHTMLPath == nil{
                indexHTMLPath = foundIndexPath
            }
        }
        var theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.addScriptMessageHandler(messageHandler, name: "interOp")
        
        webView = WKWebView(frame: theViewController.view.frame, configuration: theConfiguration)
        var url = NSURL(fileURLWithPath: indexHTMLPath!)
        var request = NSURLRequest(URL: url!)
        webView!.loadRequest(request)
        theViewController.view.addSubview(webView!)
    }
    else{
        creationError = SwiftlyHybridError(description: "Error: The view controller for your application must implement the WKScriptMessagehandler protocol")
    }
    return (webView,creationError)
    
}

internal func moveWebFiles(movableFileTypes:[String])->(String?, String?){
    let fileManager = NSFileManager.defaultManager()
    
    var indexPath:String?
    let resourcesPath = NSBundle.mainBundle().resourcePath
    let tempPath = NSTemporaryDirectory()
    var anError:NSError?
    let resourcesList = fileManager.contentsOfDirectoryAtPath(resourcesPath!, error: &anError) as [String]
    for resourceName in resourcesList{
        var isMovableType = false
        for fileType in movableFileTypes{
            if resourceName.lowercaseString.hasSuffix(fileType){
                isMovableType = true
            }
        }
        
        if isMovableType{
            let destinationPath = tempPath.stringByAppendingPathComponent(resourceName)
            if fileManager.fileExistsAtPath(destinationPath){
                var removeError:NSError?
                fileManager.removeItemAtPath(destinationPath, error:&removeError)
                if let errorDescription = removeError?.description{
                    return (nil,errorDescription)
                }
            }
            let resourcePath = resourcesPath!.stringByAppendingPathComponent(resourceName)
            var copyError:NSError?
            fileManager.copyItemAtPath(resourcePath, toPath: destinationPath, error: &copyError)
            if let errorDescription = copyError?.description{
                return (nil, errorDescription)
            }
            if resourceName.lowercaseString == "index.html"{
                indexPath = destinationPath
            }
        }
    }
    return (indexPath,nil)
}

internal func moveDirectories(topLevelDirectoryNames:[String]) -> (String?, String?){
    var indexHTMLPath:String?
    var moveErrorDescription:String?
    
    let bundlePath = NSBundle.mainBundle().resourcePath
    let tempPath = NSTemporaryDirectory()


    var anError:NSError?
    let fileManager = NSFileManager.defaultManager()
    let resourcesList = fileManager.contentsOfDirectoryAtPath(bundlePath!, error: &anError) as [String]
    for resourceName in resourcesList{
        var isDirectoryType:ObjCBool = false
        let resourcePath = bundlePath?.stringByAppendingPathComponent(resourceName)
        let found = fileManager.fileExistsAtPath(resourcePath!, isDirectory: &isDirectoryType)
        if isDirectoryType && !resourceName.hasSuffix(".lproj")
                            && resourceName != "Frameworks"
                            && resourceName != "META-INF"
                            && resourceName != "_CodeSignature"{
            let sourcePath = bundlePath?.stringByAppendingPathComponent(resourceName)
            let destinationPath = tempPath.stringByAppendingPathComponent(resourceName)
            if fileManager.fileExistsAtPath(destinationPath){
                var removeError:NSError?
                fileManager.removeItemAtPath(destinationPath, error:&removeError)
                if let errorDescription = removeError?.description{
                    return (nil,errorDescription)
                }
            }
            var copyError:NSError?
            fileManager.copyItemAtPath(sourcePath!, toPath: destinationPath, error: &copyError)
            if let errorDescription = copyError?.description{
                return (nil, errorDescription)
            }
        }
        
        

    }
    return (indexHTMLPath,moveErrorDescription)
}


