//
//  WebViewCompatible.swift
//  OnePassword
//
//  Created by Christopher Beloch on 24.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation
import WebKit

public protocol WebViewCompatible {
    func eval(javaScript: String, completion: @escaping (_ result: String?, _ error: Error?) -> ())
}

extension UIWebView: WebViewCompatible {
    public func eval(javaScript: String, completion: @escaping (String?, Error?) -> ()) {
        let response = self.stringByEvaluatingJavaScript(from: javaScript)
        completion(response, nil)
    }
}

extension WKWebView: WebViewCompatible {
    public func eval(javaScript: String, completion: @escaping (String?, Error?) -> ()) {
        self.evaluateJavaScript(javaScript) { (response, error) in
            completion(response as? String, error)
        }
    }
}
