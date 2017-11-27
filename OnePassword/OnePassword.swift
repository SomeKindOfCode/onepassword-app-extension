//
//  OnePassword.swift
//  OnePassword
//
//  Created by Christopher Beloch on 24.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation
import MobileCoreServices


// TODO: Everything

public typealias OnePasswordLoginDictionaryCompletionBlock = (_ loginDictionary: [String:String]?, _ error: Error?) -> ()
public typealias OnePasswordSuccessCompletionBlock = (_ success: Bool, _ error: Error?) -> ()
public typealias OnePasswordExtensionItemCompletionBlock = (_ extensionItem: NSExtensionItem?, _ error: Error?) -> ()

public class OnePasswordExtention {    
    public static var isAppExtentionAvailable: Bool { 
        return UIApplication.shared.canOpenURL(URL(string: "org-appextension-feature-password-management://")!)
    }
    
    /// 
    public class func findLogin(urlString: String, viewController: UIViewController, sender: Any?, completion: @escaping OnePasswordLoginDictionaryCompletionBlock) {
        guard self.isAppExtentionAvailable else {
            // ???: Maybe throw errors?
            completion(nil, OnePasswordError.apiNotAvailable)
            return
        }
        
        // Create Activity Item
        var item = [String: Any]()
        item[Constants.Keys.versionNumber] = Constants.versionNumber
        item[Constants.Keys.urlString] = urlString
        
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
    
    public class func storeLogin(urlString: String, loginDetails loginDetailsDictionary: [String: String]?, passwordGenerationOptions: [String: String]?, viewController: UIViewController, sender: Any?, completion: OnePasswordLoginDictionaryCompletionBlock) {}
    public class func changePassword(urlString: String, loginDetails loginDetailsDictionary: [String: String]?, passwordGenerationOptions: [String: String]?, viewController: UIViewController, sender: Any?, completion: OnePasswordLoginDictionaryCompletionBlock) {}
    public class func fillItemInto(webView: WebViewCompatible, for viewController: UIViewController, sender: Any?, showOnlyLogins: Bool, completion: OnePasswordSuccessCompletionBlock) {}
    
    public class func isOnePasswordExtensionActivityType(_ activityType: String) -> Bool { return false }
    
    public class func createExtension(for webView: WebViewCompatible, completion: OnePasswordExtensionItemCompletionBlock) {}
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
}

func debugLog(_ message: String, function: String = #function) {
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    Swift.print("[OnePassword \(function)] ⚠️ \(message)")
    #endif
}
