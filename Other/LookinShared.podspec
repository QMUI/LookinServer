Pod::Spec.new do |spec|
  spec.name         = 'LookinShared'
  spec.version      = '1.0.1'
  spec.license      = 'GPL-3.0'
  spec.summary      = 'The shared files between client and server side of Lookin.'
  spec.homepage     = 'https://lookin.work'
  spec.author       = { "Li Kai" => "lookin@lookin.work" }
  #spec.source       = { :git => "https://github.com/QMUI/LookinServer.git", :tag => "1.0.1"}
  spec.requires_arc = true
  spec.source_files = '../Src/Shared/**/*'
  spec.ios.deployment_target  = '9.0'
  #spec.macos.deployment_target  = '10.14'
end
