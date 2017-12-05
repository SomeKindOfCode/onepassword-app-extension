Pod::Spec.new do |spec|

  spec.name             = "1PasswordExtension-Swift"
  spec.module_name      = "OnePasswordExtension-Swift"
  spec.version          = "2.0"
  spec.summary          = "With just a few lines of code, your app can add Password Manager support."
  spec.description      = <<-DESC
 							With just a few lines of code, your app can add Password Manager support, enabling your users to:

 							- Access their Logins stored in a password manager to automatically fill your login page.
 							- Quickly fill Logins directly into web views.

 							Empowering your users to use strong, unique passwords has never been easier.
 							DESC

  spec.homepage         = "https://github.com/SomeKindOfCode/onepassword-app-extension"
  spec.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  spec.authors          = [ "Dave Teare", "Michael Fey", "Rad Azzouz", "Roustem Karimov", "Christopher Beloch" ]
  spec.social_media_url = "https://twitter.com/somekindofcode"

  spec.source           = { :git => "https://github.com/SomeKindOfCode/onepassword-app-extension.git", :tag => spec.version }
  spec.platform         = :ios, 8.0
  spec.source_files     = "*.{swift}"
  spec.frameworks       = [ 'Foundation', 'MobileCoreServices', 'UIKit' ]
  spec.weak_framework   = "WebKit"
  spec.exclude_files    = "App Example Swift"
  spec.resource_bundles = { 'OnePasswordExtensionResources' => ['OnePassword/1Password.xcassets/*.imageset/*.png', '1Password.xcassets'] }
  spec.requires_arc     = true
end
