# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'impasta/version'

Gem::Specification.new do |spec|
  spec.name          = 'impasta'
  spec.version       = Impasta::VERSION
  spec.authors       = ['Anthony M. Cook']
  spec.email         = ['me@anthonymcook.com']
  spec.summary       = %q{Test spy for Ruby.}
  spec.description   = %q{A test spy that can impersonate a given class and/or track methods passed to it.}
  spec.homepage      = 'https://github.com/acook/impasta'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split(?\x0)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'uspec', '~> 0.1.1'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
end
