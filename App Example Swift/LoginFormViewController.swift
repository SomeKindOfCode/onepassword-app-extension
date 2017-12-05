//
//  LoginFormViewController.swift
//  App Example Swift
//
//  Created by Christopher Beloch on 24.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import UIKit
import OnePassword

class LoginFormViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var onePassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.onePassButton.setImage(
            UIImage(
                named: "onepassword-button", 
                in: Bundle(for: OnePasswordExtention.self), 
                compatibleWith: nil
            ), 
            for: .normal
        )
    }
    
    @IBAction func onePassButtonTapped(_ sender: Any) {
        OnePasswordExtention.findLogin(urlString: "https://www.acme.com", viewController: self, sender: sender) { (loginDictionary, error) in
            
            self.usernameTextField.text = loginDictionary?[onepass: .username]
            self.passwordTextField.text = loginDictionary?[onepass: .password]
        }
    }
}

