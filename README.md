This is an unofficial port of the [1Password Extension by AgileBits](https://github.com/agilebits/onepassword-app-extension) to Swift

# 1Password App Extension

[![CocoaPods](https://img.shields.io/cocoapods/l/1PasswordExtension.svg)](https://github.com/AgileBits/onepassword-app-extension/blob/master/LICENSE.txt)
[![CocoaPods](https://img.shields.io/cocoapods/v/1PasswordExtension.svg)](https://github.com/AgileBits/onepassword-app-extension/wiki/CocoaPods)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/AgileBits/onepassword-app-extension/wiki/Carthage)

Welcome! With just a few lines of code, your app can add 1Password support, enabling your users to:

1. Access their 1Password Logins to automatically fill your login page.
2. Use the Strong Password Generator to create unique passwords during registration, and save the new Login within 1Password.
3. Quickly fill 1Password Logins, Credit Cards and Identities directly into web views.

Empowering your users to use strong, unique passwords has never been easier. Let's get started!

## App Extension in Action

<a href="https://vimeo.com/102142106" target="_blank"><img src="https://com-agilebits-users.s3.amazonaws.com/rad/onepassword-app-extension/images/1Password_App_Extension_Play_Video.png" width="640" height="360"></a>

## Install

This Swift port is currently under development!

### Carthage

```ruby
github "SomeKindOfCode/onepassword-app-extension" "feature/swift"
```

### CocoaPods

*Currently not available*

## State of Swift port

Swift Version: 4.0

Implementations:

- [x] [Find Login](#fill-login) *(e.g. to fill In-App Form)*
- [x] [Fill Form inside WebView](#fill-webview) *(UIWebView and WKWebView supported)*
- [ ] Store Login
- [ ] Change Password

## Supported Password Manager

These managers have been tested to support the generic protocol to return **at least** a selected login:

- 1Password
- LastPass
- Enpass
- Dashlane

Coming (soon):

- RememBear

## Usage

### Find Login

Use this to let the user pick a login by domain and fill a custom form inside your app

```swift
OnePasswordExtention.findLogin(urlString: "https://www.acme.com", viewController: self, sender: sender) { (loginDictionary, error) in
    self.usernameTextField.text = loginDictionary?[onepass: .username]
    self.passwordTextField.text = loginDictionary?[onepass: .password]
}
```

### Fill WebView

You can use the extension to help the user log into a website you embedded inside either a `UIWebView` or a `WKWebView`

```swift
OnePasswordExtention.fillItemInto(webView: self.webView, for: self, sender: sender, showOnlyLogins: false) { (success, error) in
    if !success {
        print("Failed to fill into webview: <\(String(describing: error))>")
    }
}
```

Note that when you use `SFWebViewController`, you will give the user regular access to the regular action via the share button as the user is familiar with by using Safari.

## Let's get Swifty

As you maybe noted, there are a few helper implemented for you to make life a little easier.

The `loginDictionary` objects, returned from methods like `findLogin` have a custom subscript that accepts the `Constants.Keys` enum. This should help you find the values you are looking for.

There is also a `OnePasswordError` enum that helps you identify different errors that could happen while using the Framework.

As we don't know if there will be another successor to the `WKWebView`, there is a protocol named `WebViewCompatible`[^1 ] so this can be added to any successor or custom WebView implementations[^2].

## Best Practices

* Use the same `URLString` during Registration and Login.
* Ensure your `URLString` is set to your actual service so your users can easily find their logins within the main 1Password app.
* You should only ask for the login information of your own service or one specific to your app. Giving a URL for a service which you do not own or support may seriously break the customer's trust in your service/app.
* If you don't have a website for your app you should specify your bundle identifier as the `URLString`, like so: `app://bundleIdentifier` (e.g. `app://com.acme.awesome-app`).
* [Send us an icon](mailto:support+appex@agilebits.com) to use for our Rich Icon service so the user can see your lovely icon after creating new items. Please send an icon that is 1024x1024px. Make sure that you also include the URL string that you used, so we can associate it with the icon on our Rich Icons server.
* Use the icons provided in the `1Password.xcassets` asset catalog so users are familiar with what it will do. Contact us if you'd like additional sizes or have other special requirements.
* On your registration page, pre-validate fields before calling 1Password. For example, display a message if the username is not available so the user can fix it before calling the 1Password extension.


## References

If you open up OnePasswordExtension.m and start poking around, you'll be interested in these references.

* [Apple Extension Guide](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/ExtensibilityPG/index.html#//apple_ref/doc/uid/TP40014214)
* [NSItemProvider](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSItemProvider_Class/index.html#//apple_ref/doc/uid/TP40014351), [NSExtensionItem](https://developer.apple.com/library/prerelease/ios/documentation/Foundation/Reference/NSExtensionItem_Class/index.html#//apple_ref/doc/uid/TP40014375), and [UIActivityViewController](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIActivityViewController_Class/index.html#//apple_ref/doc/uid/TP40011976) class references.








[^1 ]: The extension made UIWebView and WKWebView conform to this protocol to save some lines of code
[^2 ]: Are there any Chrome-/FireFox-/Edge-WebViews?