//
//  Extensions.swift
//  OnePassword
//
//  Created by Christopher Beloch on 27.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String {
    subscript (onepass onepass: Constants.Keys) -> Value? {
        get {
            return self[onepass.rawValue]
        }
        set {
            self[onepass.rawValue] = newValue
        }
    }
}
