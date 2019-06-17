# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "impasta/version"

Gem::Specification.new do |gem|
  gem.name          = "impasta"
  gem.version       = Impasta::VERSION
  gem.authors       = ["Anthony M. Cook"]
  gem.email         = ["me@anthonymcook.com"]
  gem.summary       = %q{Test spy for Ruby.}
  gem.description   = %q{A test spy that can impersonate a given class and/or track methods passed to it.}
  gem.homepage      = "https://github.com/acook/impasta"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split(?\x0)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(uspec)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", ">= 1.5"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "uspec", '>= 1.0.1'

  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-doc"
end
