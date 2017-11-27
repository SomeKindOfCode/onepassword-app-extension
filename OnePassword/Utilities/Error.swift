//
//  Error.swift
//  OnePassword
//
//  Created by Christopher Beloch on 25.11.17.
//  Copyright © 2017 Some Kind of Code. All rights reserved.
//

import Foundation

enum OnePasswordError: Error {
    case cancelledByUser
    case apiNotAvailable
    case failedToContactExtension
    case failedToLoadItemProviderData
    case collectFieldsScriptFailed
    case fillFieldsScriptFailed
    case unexpectedData
    case failedToObtainURLStringFromWebView
}
