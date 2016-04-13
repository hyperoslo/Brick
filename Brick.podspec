Pod::Spec.new do |s|
  s.name             = "Brick"
  s.summary          = "A generic view model for both basic and complex scenarios."
  s.version          = "0.4.0"
  s.homepage         = "https://github.com/hyperoslo/Brick"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = {
    :git => "https://github.com/hyperoslo/Brick.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.requires_arc = true
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{Mac,Shared}/**/*'

  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.osx.frameworks = 'Cocoa', 'Foundation'

  s.dependency 'Sugar', '~> 1.0'
  s.dependency 'Tailor'
end
