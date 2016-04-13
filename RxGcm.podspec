Pod::Spec.new do |s|
  s.name         = "RxGcm"
  s.version      = "0.0.1"
  s.summary      = "RxSwift extension for iOS Google Cloud Messaging (aka gcm)."

  s.homepage     = "https://github.com/FuckBoilerplate/RxGcm-iOS"
  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Roberto Frontado" => "robertofrontado@gmail.com" }
  s.source           = { :git => "https://github.com/FuckBoilerplate/RxGcm-iOS.git", :tag => s.version.to_s }
  s.social_media_url   = "https://github.com/FuckBoilerplate"

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*'

  # s.public_header_files = 'Sources/**/*.h'

  s.dependency 'RxSwift', '~> 2.0.0'
  s.dependency 'Google/CloudMessaging'
  
end