$:.push File.expand_path('lib', __dir__)
require 'handlebars_assets/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '~> 2.6'

  s.name        = 'handlebars_assets'
  s.version     = HandlebarsAssets::VERSION
  s.authors     = ['EZCall']
  s.licenses    = ['MIT']
  s.homepage    = 'https://github.com/EZCall/handlebars_assets'
  s.summary     = 'Compile Handlebars templates in the Rails asset pipeline.'

  s.metadata['rubygems_mfa_required'] = 'true'

  s.rubyforge_project = 'handlebars_assets'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'execjs',    '~> 2.0'
  s.add_runtime_dependency 'sprockets', '>= 2.0.0'
  s.add_runtime_dependency 'tilt',      '>= 1.2'

  s.add_development_dependency 'haml', '~> 4.0'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'slim', '~> 3.0'
end
