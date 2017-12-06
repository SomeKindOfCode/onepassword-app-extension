//
//  OnePassword.swift
//  OnePassword
//
//  Created by Christopher Beloch on 24.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation
import MobileCoreServices

public typealias OnePasswordLoginDictionaryCompletionBlock = (_ loginDictionary: [String:String]?, _ error: Error?) -> ()
public typealias OnePasswordSuccessCompletionBlock = (_ success: Bool, _ error: Error?) -> ()
public typealias OnePasswordExtensionItemCompletionBlock = (_ extensionItem: NSExtensionItem?, _ error: Error?) -> ()

public class OnePasswordExtention {    
    /// *true* if any app that supports the generic `org-appextension-feature-password-management` feature is installed on the device.
    public static var isAppExtentionAvailable: Bool { 
        return UIApplication.shared.canOpenURL(URL(string: "org-appextension-feature-password-management://")!)
    }
    
    /// Called from your login page, this method will find all available logins for the given URLString.
    ///
    /// - Parameters:
    ///     - urlString: For the matching Logins in the password vault
    ///     - viewController: The view controller from which the password Extension is invoked. Usually `self`
    ///     - sender: The sender which triggers the share sheet to show. UIButton, UIBarButtonItem or UIView. Can also be nil on iPhone, but not on iPad.
    ///     - completion: A completion block called with two parameters loginDictionary and error once completed. The loginDictionary reply parameter that contains the username, password and the One-Time Password if available. The error Reply parameter that is nil if the 1Password Extension has been successfully completed, or it contains error information about the completion failure.
    public class func findLogin(urlString: String, viewController: UIViewController, sender: Any?, completion: @escaping OnePasswordLoginDictionaryCompletionBlock) {
        guard self.isAppExtentionAvailable else {
            // ???: Maybe throw errors?
            completion(nil, OnePasswordError.apiNotAvailable)
            return
        }
        
        // Create Activity Item
        var item = [String: Any]()
        item[onepass: .versionNumber] = Constants.versionNumber
        item[onepass: .urlString] = urlString
        
        let activityController = self.activityViewController(for: item, viewController: viewController, sender: sender, typeIdentifier: .findLogin)
        
        activityController.completionWithItemsHandler = { (activity, isCompleted, items, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard items?.count ?? 0 > 0 else {
                completion(nil, OnePasswordError.cancelledByUser)
                return
            }
            
            self.process(extensionItem: items?.first as? NSExtensionItem, completion: completion)
        }
        
        // Display Activity View Controller
        DispatchQueue.main.async {
            viewController.present(activityController, animated: true, completion: nil)
        }
    }
    
    // TODO: !!!
    public class func storeLogin(urlString: String, loginDetails loginDetailsDictionary: [String: String]?, passwordGenerationOptions: [String: String]?, viewController: UIViewController, sender: Any?, completion: OnePasswordLoginDictionaryCompletionBlock) {}
    
    // TODO: !!!
    public class func changePassword(urlString: String, loginDetails loginDetailsDictionary: [String: String]?, passwordGenerationOptions: [String: String]?, viewController: UIViewController, sender: Any?, completion: OnePasswordLoginDictionaryCompletionBlock) {}
    
    public class func fillItemInto(webView: WebViewCompatible, for viewController: UIViewController, sender: Any?, showOnlyLogins: Bool, completion: @escaping OnePasswordSuccessCompletionBlock) {
        guard let url = webView.url else {
            completion(false, OnePasswordError.failedToObtainURLStringFromWebView)
            return
        }
        
        // Collect fields
        webView.eval(javaScript: Scripts.collectFields) { (result, error) in
            guard let collectedPageDetails = result else {
                completion(false, OnePasswordError.collectFieldsScriptFailed)
                return
            }
            
            let urlString = url.absoluteString
            
            let data = collectedPageDetails.data(using: .utf8)!
            do {
                let collectionPageDetailsDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                var item: [String: Any] = [:]
                item[onepass: .versionNumber] = Constants.versionNumber
                item[onepass: .urlString] = urlString
                item[onepasswv: .pageDetails] = collectionPageDetailsDictionary
                
                let typeIdentifier: Constants.ExtensionActions = showOnlyLogins ? .fillWebView : .fillBrowser
                
                let activityController = self.activityViewController(for: item, viewController: viewController, sender: sender, typeIdentifier: typeIdentifier)
                activityController.completionWithItemsHandler = { (activity, isCompleted, items, error) in
                    guard 
                        let returnedItems = items, 
                        returnedItems.count > 0 
                    else {
                        completion(false, error ?? OnePasswordError.cancelledByUser)
                        return
                    }
                    
                    self.process(extensionItem: returnedItems.first as? NSExtensionItem, completion: { (itemDictionary, error) in
                        guard 
                            let dict = itemDictionary,
                            dict.count > 0
                        else {
                            completion(false, error)
                            return
                        }
                        
                        let fillScript = dict[onepasswv: .fillScript]
                        self.execute(fillScript: fillScript, in: webView, completion: completion)
                    })
                }
                
                // Display Activity View Controller
                DispatchQueue.main.async {
                    viewController.present(activityController, animated: true, completion: nil)
                }
            } catch {
                // Some other errors occured white JSON serialization
                completion(false, error)
            }
        }
    }
    
    // TODO: !!!
    public class func isOnePasswordExtensionActivityType(_ activityType: String) -> Bool { return false }
    // TODO: !!!
    public class func createExtension(for webView: WebViewCompatible, completion: OnePasswordExtensionItemCompletionBlock) {}
    // TODO: !!!
    public class func fill(returnedItems: [String]?, into webView: Any, completion: OnePasswordSuccessCompletionBlock) {}
}

// MARK: Internals

extension OnePasswordExtention {
    class func activityViewController(for item: [String: Any], viewController: UIViewController, sender: Any?, typeIdentifier: Constants.ExtensionActions) -> UIActivityViewController {
        if UIDevice.current.userInterfaceIdiom == .pad && sender == nil {
            debugLog("sender must not be nil on iPad")
        }
        
        let provider: NSItemProvider = NSItemProvider(item: item as NSDictionary, typeIdentifier: typeIdentifier.rawValue)
        
        let extensionItem: NSExtensionItem = NSExtensionItem()
        extensionItem.attachments = [provider]
        
        let controller = UIActivityViewController(activityItems: [extensionItem], applicationActivities: nil)
        
        if let barButtonSender = sender as? UIBarButtonItem {
            controller.popoverPresentationController?.barButtonItem = barButtonSender
        } else if let viewSender = sender as? UIView {
            controller.popoverPresentationController?.sourceView = viewSender.superview
            controller.popoverPresentationController?.sourceRect = viewSender.frame
        } else {
            debugLog("sender had an invalid type")
        }
        
        return controller
    }
    
    class func process(extensionItem: NSExtensionItem?, completion: @escaping OnePasswordLoginDictionaryCompletionBlock) {
        guard 
            let attachments = extensionItem?.attachments, 
            attachments.count > 0 
        else {
            completion(nil, OnePasswordError.unexpectedData("extension item had no attachments"))
            return
        }
        
        guard 
            let itemProvider = attachments.first as? NSItemProvider,
            itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String)
        else {
            completion(nil, OnePasswordError.unexpectedData("extension item attachment does not conform to kUTTypePropertyList type identifier"))
            return
        }
        
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) { (itemDictionary, error) in
            guard 
                let itemDictionary = itemDictionary as? [String: String],
                itemDictionary.count > 0
            else {
                completion(nil, OnePasswordError.failedToLoadItemProviderData)
                return
            }
            
            DispatchQueue.main.async {
                completion(itemDictionary, nil)
            }
        }
    }
    
    class func execute(fillScript: String?, in webView: WebViewCompatible, completion: @escaping OnePasswordSuccessCompletionBlock) {
        guard let script = fillScript else { 
            completion(false, OnePasswordError.fillFieldsScriptFailed)
            return
        }
        
        let scriptSource = Scripts.fill.appendingFormat("(document, %@, undefined);", script)
        webView.eval(javaScript: scriptSource) { (result, error) in
            guard result != nil, error == nil else {
                completion(false, error)
                return
            }
            
            completion(true, error)
        }
    }
}

func debugLog(_ message: String, function: String = #function) {
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    Swift.print("[OnePassword \(function)] ⚠️ \(message)")
    #endif
}
