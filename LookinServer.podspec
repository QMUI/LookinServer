Pod::Spec.new do |spec|
  spec.name         = "LookinServer"
  spec.version      = "0.9.4"
  spec.summary      = "The iOS framework of Lookin."
  spec.description  = "Embed this framework into your iOS project to enable Lookin mac app."
  spec.homepage     = "https://lookin.work"
  spec.license      = "GPL-3.0"
  spec.author       = { "QMUI Team" => "lookin@lookin.work" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/QMUI/LookinServer.git", :tag => "0.9.4"}
  spec.vendored_frameworks = "LookinServer.framework"
  spec.framework  = "UIKit"
end
