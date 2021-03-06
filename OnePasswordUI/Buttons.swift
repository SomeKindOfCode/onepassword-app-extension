//
//  Buttons.swift
//  OnePasswordUI
//
//  Created by Christopher Beloch on 06.12.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import UIKit

@IBDesignable
public class OnePasswordBarButtonItem: UIBarButtonItem {
    #if !TARGET_INTERFACE_BUILDER
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    #endif
    
    public override init() {
        super.init()
        
        self.setup()
    }
    
    private func setup() {
        self.image = UIImage(named: "onepassword-navbar", in: Bundle(for: self.classForCoder), compatibleWith: nil)
        self.title = nil
    }
    
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setup()
    }
}

@IBDesignable
public class OnePasswordButton: UIButton {
    #if !TARGET_INTERFACE_BUILDER
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    #endif
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    private func setup() {
        self.setImage(UIImage(named: "onepassword-button", in: Bundle(for: self.classForCoder), compatibleWith: nil), for: .normal) 
        self.setTitle(nil, for: .normal)
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setup()
    }
}
