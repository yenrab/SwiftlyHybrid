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
            let (foundIndexPath,moveError) = moveDirectories(webDirectoriesInApp!, (indexHTMLPath == nil))
            if indexHTMLPath == nil{
                indexHTMLPath = foundIndexPath
            }
        }
        println(indexHTMLPath!)
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
                break;
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

internal func moveDirectories(topLevelDirectoryNames:[String], var searchForIndexHTML:Bool) -> (String?, String?){
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
                                let destinationPath = tempPath.stringByAppendingPathComponent(resourceName)
                                if fileManager.fileExistsAtPath(destinationPath){
                                    var removeError:NSError?
                                    fileManager.removeItemAtPath(destinationPath, error:&removeError)
                                    if let errorDescription = removeError?.description{
                                        return (nil,errorDescription)
                                    }
                                }
                                var copyError:NSError?
                                fileManager.copyItemAtPath(resourcePath!, toPath: destinationPath, error: &copyError)
                                if let errorDescription = copyError?.description{
                                    return (nil, errorDescription)
                                }
                                else if searchForIndexHTML{
                                    var resources = [[String]]()
                                    var contentsError:NSError?
                                    let childResourcesList = fileManager.contentsOfDirectoryAtPath(destinationPath, error: &contentsError) as [String]
                                    if contentsError != nil{
                                        continue
                                    }
                                    for childResource in childResourcesList{
                                        resources.append([destinationPath,childResource])
                                    }
                                    let (indexHTMLFilePath,error) = searchForIndexHTMLFile(resources, 0, fileManager)
                                    if indexHTMLFilePath != nil{
                                        indexHTMLPath = indexHTMLFilePath
                                        searchForIndexHTML = false
                                    }
                                }
        }
        
        

    }
    return (indexHTMLPath,moveErrorDescription)
}
/*
 * A breadth first search for the index.html file
 */
internal func searchForIndexHTMLFile(var resources:[[String]], curIndex:Int, fileManager:NSFileManager) ->(String?, NSError?){
    let resource = resources[curIndex][1]
    let directoryPath = resources[curIndex][0]
    let resourcePath = directoryPath.stringByAppendingPathComponent(resource)
    var anError:NSError?
    if resource.lowercaseString == "index.html"{
        return (resourcePath, anError)
    }
    else{
        var isDirectoryType:ObjCBool = false
        fileManager.fileExistsAtPath(resourcePath, isDirectory: &isDirectoryType)
        if isDirectoryType{
            let resourcesList = fileManager.contentsOfDirectoryAtPath(resourcePath, error: &anError) as [String]
            if anError != nil{
                return (nil,anError)
            }
            for childResource in resourcesList{
                resources.append([resourcePath,childResource])
            }
        }
    }
    
    return searchForIndexHTMLFile(resources, curIndex + 1, fileManager)
}

