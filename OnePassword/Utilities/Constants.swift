//
//  Constants.swift
//  OnePassword
//
//  Created by Christopher Beloch on 24.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation

public class Constants {
    class ExtensionActions {
        static let findLogin: String = "org.appextension.find-login-action"
        static let saveLogin: String = "org.appextension.save-login-action"
        static let changePassword: String = "org.appextension.change-password-action"
        static let fillWebView: String = "org.appextension.fill-webview-action"
        static let fillBrowser: String = "org.appextension.fill-browser-action"
    }
    
    class WebViewDictionaryKeys {
        static let fillScript: String = "fillScript"
        static let pageDetails: String = "pageDetails"
    }
    
    public class Keys {
        public static let urlString: String = "url_string"
        public static let username: String = "username"
        public static let password: String = "password"
        public static let TOTP: String = "totp"
        public static let title: String = "login_title"
        public static let notes: String = "notes"
        public static let sectionTitle: String = "section_title"
        public static let fields: String = "fields"
        public static let returnedFields: String = "returned_fields"
        public static let oldPassword: String = "old_password"
        public static let passwordGeneratorOptions: String = "password_generator_options"
        
        static let versionNumber: String = "version_number"
    }
    
    static let versionNumber: Int = 184
}
