$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'doggo'
  s.version     = '0.0.3'
  s.date        = '2020-04-03'
  s.summary     = 'RSpec formatter - documentation, with progress indication'
  s.description = 'Similar to RSpec -f d, but adds indication of test number and total tests on each line'
  s.authors     = ['RIP Global', 'Andrew David Hodgkinson']
  s.email       = ['andrew@ripglobal.com']
  s.license     = 'MIT'

  s.files       = Dir.glob('lib/**/*.rb')
  s.bindir      = 'bin'
  s.test_files  = Dir.glob('spec/**/*.rb')
  s.homepage    = 'https://github.com/ripglobal/doggo/'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency             'rspec-core','~> 3.0'
  s.add_development_dependency 'rspec',     '~> 3.7'
end
