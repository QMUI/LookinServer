Pod::Spec.new do |spec|
  spec.name         = "LookinShared"
  spec.version      = "1.2.4"
  spec.summary      = "The shared files between client and server side of Lookin."
  spec.description  = "Embed this framework into your iOS project to enable Lookin mac app."
  spec.homepage     = "https://lookin.work"
  spec.license      = "GPL-3.0"
  spec.author       = { "Li Kai" => "lookin@lookin.work" }
  spec.ios.deployment_target  = "9.0"
  spec.tvos.deployment_target  = '9.0'
  spec.macos.deployment_target = "10.14"
  spec.source       = { :git => "https://github.com/QMUI/LookinServer.git", :tag => "1.2.4"}
  #spec.framework  = "UIKit"
  spec.requires_arc = true
  spec.source_files = [
      'Src/Main/Shared/**/*',
      'Src/Base/**/*'
  ]
  spec.exclude_files = 'Src/Main/Shared/Channel/**/*'
  spec.default_subspec = :none

  spec.pod_target_xcconfig = {
     'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) SHOULD_COMPILE_LOOKIN_SERVER=1'
  }

  spec.subspec 'Wireless' do |ss|
    ss.source_files = 'Src/Main/Shared/Channel/**/*'
    ss.dependency 'CocoaAsyncSocket'
    ss.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) LOOKIN_SERVER_WIRELESS=1'
    }
  end
end
