//
//  Constants.swift
//  OnePassword
//
//  Created by Christopher Beloch on 24.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation

public class Constants {
    enum ExtensionActions: String {
        case findLogin = "org.appextension.find-login-action"
        case saveLogin = "org.appextension.save-login-action"
        case changePassword = "org.appextension.change-password-action"
        case fillWebView = "org.appextension.fill-webview-action"
        case fillBrowser = "org.appextension.fill-browser-action"
    }
    
    class WebViewDictionaryKeys {
        static let fillScript: String = "fillScript"
        static let pageDetails: String = "pageDetails"
    }
    
    public enum Keys: String {
        case urlString = "url_string"
        case username = "username"
        case password = "password"
        case TOTP = "totp"
        case title = "login_title"
        case notes = "notes"
        case sectionTitle = "section_title"
        case fields = "fields"
        case returnedFields = "returned_fields"
        case oldPassword = "old_password"
        case passwordGeneratorOptions = "password_generator_options"
        
        case versionNumber = "version_number"
        
        enum WebView: String {
            case pageDetails
            case fillScript
        }
    }
    
    static let versionNumber: Int = 184
}
