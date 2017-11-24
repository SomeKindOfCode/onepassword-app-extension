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
    case APINotAvailable
    case FailedToContactExtension
    case FailedToLoadItemProviderData
    case CollectFieldsScriptFailed
    case FillFieldsScriptFailed
    case unexpectedData
    case failedToObtainURLStringFromWebView
}
