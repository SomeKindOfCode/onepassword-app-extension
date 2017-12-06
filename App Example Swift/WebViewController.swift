//
//  WebViewController.swift
//  App Example Swift
//
//  Created by Christopher Beloch on 04.12.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import UIKit
import WebKit
import OnePassword

class WebViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var onePassFillButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.webView.navigationDelegate = self
        
        self.onePassFillButton.isEnabled = OnePasswordExtention.isAppExtentionAvailable
        
        self.webView.load(URLRequest(url: URL(string: "https://duckduckgo.com")!))
    }
    
    // !!!!
    // THIS IS WHAT YOU CARE ABOUT
    // !!!!
    @IBAction func on1PassButtonTap(_ sender: Any) {
        OnePasswordExtention.fillItemInto(webView: self.webView, for: self, sender: sender, showOnlyLogins: false) { (success, error) in
            if !success {
                print("Failed to fill into webview: <\(String(describing: error))>")
            }
        }
    }
    
    @IBAction func onBackButtonTap(_ sender: Any) {
        self.webView.goBack()
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.searchBar.text = webView.url?.absoluteString
    }
}

extension WebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSearch(searchBar.text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.performSearch(searchBar.text)
    }
    
    func handleSearch(_ searchBar: UISearchBar) {
        self.performSearch(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.performSearch(searchBar.text)
    }
    
    // Convenience
    func performSearch(_ text: String!) {
        let lowercaseText = text.lowercased(with: Locale.current)
        var URLObj: URL?
        
        // Optimize Input a little bit
        let hasScheme = lowercaseText.hasPrefix("http:") || lowercaseText.hasPrefix("https:")
        if (hasScheme) {
            URLObj = URL(string: lowercaseText)
        } else {
            URLObj = URL(string: "https://".appending(lowercaseText))
        }
        
        self.searchBar.text = URLObj?.absoluteString
        self.searchBar.resignFirstResponder()
        
        let request = URLRequest(url: URLObj!)
        self.webView.load(request)
    }
}
