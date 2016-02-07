# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunto-sass-converter/version'

Gem::Specification.new do |spec|
  spec.name          = "bunto-sass-converter"
  spec.version       = BuntoSassConverter::VERSION
  spec.authors       = ["Parker Moore", "Suriyaa Kudo"]
  spec.email         = ["parkrmoore@gmail.com", "SuriyaaKudoIsc@users.noreply.github.com"]
  spec.summary       = %q{A basic Sass converter for Bunto.}
  spec.homepage      = "https://github.com/bunto/bunto-sass-converter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").grep(%r{^lib/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sass", "~> 3.4"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bunto", ">= 1.0"
end
