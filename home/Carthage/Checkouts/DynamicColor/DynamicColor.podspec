Pod::Spec.new do |s|
  s.name             = 'DynamicColor'
  s.version          = '2.3.0'
  s.license          = 'MIT'
  s.summary          = 'Yet another extension to manipulate colors easily in Swift'
  s.homepage         = 'https://github.com/yannickl/DynamicColor.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/DynamicColor.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/dynamiccolor-sample-screenshot.png'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.9'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.ios.framework     = 'UIKit'
  s.osx.framework     = 'AppKit'
  s.tvos.framework    = 'UIKit'
  s.watchos.framework = 'UIKit'

  s.source_files = 'DynamicColor/*.swift'
  s.requires_arc = true
end
