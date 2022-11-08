Pod::Spec.new do |spec|
  spec.name         = "LookinServer"
  spec.version      = "1.1.1"
  spec.summary      = "The iOS framework of Lookin."
  spec.description  = "Embed this framework into your iOS project to enable Lookin mac app."
  spec.homepage     = "https://lookin.work"
  spec.license      = "GPL-3.0"
  spec.author       = { "Li Kai" => "lookin@lookin.work" }
  spec.ios.deployment_target  = "9.0"
  spec.tvos.deployment_target  = '9.0'
  spec.default_subspecs = 'Core'
  spec.source       = { :git => "https://github.com/QMUI/LookinServer.git", :tag => "1.1.1"}
  spec.framework  = "UIKit"
  spec.requires_arc = true
  spec.user_target_xcconfig = {
    'GENERATE_INFOPLIST_FILE' => 'YES'
  }
    
  spec.subspec 'Core' do |ss|
    ss.source_files = ['Src/Main/**/*', 'Src/Base/**/*']
    ss.pod_target_xcconfig = {
       'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) SHOULD_COMPILE_LOOKIN_SERVER=1',
       'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) SHOULD_COMPILE_LOOKIN_SERVER'
    }
  end

  spec.subspec 'Swift' do |ss|
    ss.dependency 'LookinServer/Core'
    ss.source_files = 'Src/Swift/**/*'
    ss.pod_target_xcconfig = {
       'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) LOOKIN_SERVER_SWIFT_ENABLED=1',
       'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) LOOKIN_SERVER_SWIFT_ENABLED'
    }
 end
end
