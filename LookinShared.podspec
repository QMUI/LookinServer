Pod::Spec.new do |spec|
  spec.name         = "LookinShared"
  spec.version      = "1.0.5"
  spec.summary      = "The shared files between client and server side of Lookin."
  spec.description  = "Embed this framework into your iOS project to enable Lookin mac app."
  spec.homepage     = "https://lookin.work"
  spec.license      = "GPL-3.0"
  spec.author       = { "Li Kai" => "lookin@lookin.work" }
  spec.ios.deployment_target  = "9.0"
  spec.tvos.deployment_target  = '9.0'
  spec.macos.deployment_target = "10.14"

  spec.source       = { :git => "https://github.com/QMUI/LookinServer.git", :tag => "1.0.5"}
  #spec.framework  = "UIKit"
  spec.requires_arc = true
  spec.source_files = 'Src/Shared/**/*'
end
