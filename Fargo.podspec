Pod::Spec.new do |s|
  s.name = 'Fargo'
  s.version = '0.9'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'Easy & fast JSON deserializing library'
  s.homepage = 'https://github.com/ivasic/Fargo'
  s.social_media_url = 'http://twitter.com/ivasic'
  s.authors = { 'Ivan Vasic' => nil }
  s.source = { :git => 'https://github.com/ivasic/Fargo.git', :tag => "v#{s.version}"  }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Fargo/**/*.swift'
  s.requires_arc = true
end
