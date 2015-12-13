Pod::Spec.new do |s|
  s.name = 'Tribute'
  s.version = '1.0'
  s.summary = 'Programmatic creation of NSAttributedString doesn't have to be a pain'
  s.homepage = 'https://github.com/zats/Tribute'
  s.authors = { 'Sash Zats' => 'sash@zats.io' }
  s.source = { :git => 'https://github.com/zats/Tribute.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Tribute/*.swift'

  s.requires_arc = true
end
