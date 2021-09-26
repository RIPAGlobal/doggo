$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'doggo'
  s.version     = '1.2.0'
  s.date        = '2021-09-27'
  s.summary     = 'RSpec 3 formatter - documentation, with progress indication'
  s.description = 'Similar to "rspec -f d", but also indicates progress by showing the current test number and total test count on each line.'
  s.authors     = ['RIPA Global', 'Andrew David Hodgkinson']
  s.email       = ['andrew@ripaglobal.com']
  s.license     = 'MIT'
  s.homepage    = 'https://www.ripaglobal.com/'

  s.metadata['homepage_uri'   ] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/ripaglobal/doggo/'
  s.metadata['bug_tracker_uri'] = 'https://github.com/ripaglobal/doggo/issues/'
  s.metadata['changelog_uri'  ] = 'https://github.com/ripaglobal/doggo/blob/master/CHANGELOG.md'

  s.required_ruby_version = '>= 1.9.3'
  s.bindir                = 'bin'
  s.files                 = Dir.glob('lib/**/*.rb')
  s.test_files            = Dir.glob('spec/**/*.rb')
  s.extra_rdoc_files      = ['LICENSE.txt', 'README.md']

  s.add_dependency             'rspec-core','~> 3.10'
  s.add_development_dependency 'rspec',     '~> 3.10'
end
