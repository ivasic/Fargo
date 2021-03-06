Pod::Spec.new do |s|
  s.name = 'Fargo'
  s.version = '1.0.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'Extra easy, clean & fast JSON deserializing library written in Swift'
  s.homepage = 'https://github.com/ivasic/Fargo'
  s.social_media_url = 'http://twitter.com/ivasic'
  s.authors = { 'Ivan Vasic' => nil }
  s.source = { :git => 'https://github.com/ivasic/Fargo.git', :tag => "v#{s.version}"  }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Fargo/**/*.swift'
  s.requires_arc = true
end
