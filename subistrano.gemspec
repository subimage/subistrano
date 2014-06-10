# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subistrano/version'

Gem::Specification.new do |spec|
  spec.name          = "subistrano"
  spec.version       = Subistrano::VERSION
  spec.authors       = ["Seth B"]
  spec.email         = ["stb@subimage.com"]
  spec.description   = %q{A collection of shared Capistrano recipes for site deployment}
  spec.summary       = %q{Shared capistrano utility tasks}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
