# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blueprint_agreement/version'

Gem::Specification.new do |spec|
  spec.name          = "blueprint_agreement".freeze
  spec.version       = BlueprintAgreement::VERSION
  spec.authors       = ["Charly Palencia"]
  spec.email         = ["charly.palencia@koombea.com"]
  spec.summary       = %q{A Minitest API Documentation Matcher , based on ApiBluePrint schema.}
  spec.description   = %q{A Minitest API Documentation Matcher , based on ApiBluePrint schema.}
  spec.homepage      = "https://github.com/charly-palencia/blueprint-agreement"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "activesupport", ">= 4.2", "< 5.1"
  spec.add_runtime_dependency "minitest", "~>5.9"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~>11.1"
  spec.add_development_dependency 'minitest', "~>5.9"
  spec.add_development_dependency 'mocha', "~>1.1"
  spec.add_development_dependency 'byebug', "~>9.0"
end
