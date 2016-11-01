#
#  Be sure to run `pod spec lint LvBrowScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name         = "LvImageSwitcher"
s.version      = "0.0.1"
s.summary      = "图片选择"
s.description  = "图片选择。"
s.homepage     = "https://github.com/PlacidoLv/LvImageSwitcher"
s.license      = "MIT"
s.author       = { "PlacidoLv" => "327853338@qq.com" }
s.platform     = :ios
s.source       = { :git => "https://github.com/PlacidoLv/LvImageSwitcher.git", :tag => "0.0.1",:commit => "c8474553289b80026a36df43bf63088160fc73b6" }
s.source_files  = "LvImageSwitcher/*"
s.requires_arc = true
s.dependency  'MBProgressHUD'
end
