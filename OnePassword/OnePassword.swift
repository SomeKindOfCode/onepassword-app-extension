//
//  OnePassword.swift
//  OnePassword
//
//  Created by Christopher Beloch on 24.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation

// TODO: Everything

public typealias OnePasswordLoginDictionaryCompletionBlock = (_ loginDictionary: [String:String], _ error: Error) -> ()
public typealias OnePasswordSuccessCompletionBlock = (_ success: Bool, _ error: Error) -> ()
public typealias OnePasswordExtensionItemCompletionBlock = (_ extensionItem: NSExtensionItem, _ error: Error) -> ()

public class OnePassword {    
    public static var isAppExtentionAvailable: Bool { return false }
    
    public class func findLogin(urlString: String, viewController: UIViewController, sender: Any?, completion: OnePasswordLoginDictionaryCompletionBlock) {}
    public class func storeLogin(urlString: String, loginDetails loginDetailsDictionary: [String: String]?, passwordGenerationOptions: [String: String]?, viewController: UIViewController, sender: Any?, completion: OnePasswordLoginDictionaryCompletionBlock) {}
    public class func changePassword(urlString: String, loginDetails loginDetailsDictionary: [String: String]?, passwordGenerationOptions: [String: String]?, viewController: UIViewController, sender: Any?, completion: OnePasswordLoginDictionaryCompletionBlock) {}
    public class func fillItemInto(webView: WebViewCompatible, for viewController: UIViewController, sender: Any?, showOnlyLogins: Bool, completion: OnePasswordSuccessCompletionBlock) {}
    
    public class func isOnePasswordExtensionActivityType(_ activityType: String) -> Bool { return false }
    
    public class func createExtension(for webView: WebViewCompatible, completion: OnePasswordExtensionItemCompletionBlock) {}
    public class func fill(returnedItems: [String]?, into webView: Any, completion: OnePasswordSuccessCompletionBlock) {}
}
