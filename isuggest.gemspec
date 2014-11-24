# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'isuggest/version'

Gem::Specification.new do |spec|
  spec.name          = "isuggest"
  spec.version       = Isuggest::VERSION
  spec.authors       = ["roshandevadiga"]
  spec.email         = ["roshan.devadiga@gmail.com"]
  spec.summary       = %q{This gem will give suggestions for the fields that should be unique.}
  spec.description   = %q{Include this in your model and pass the column name that should be unique. Based on the column if the column is already present the gem will provide you suggesstions}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
