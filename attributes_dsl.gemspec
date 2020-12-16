$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "attributes_dsl/version"

Gem::Specification.new do |gem|
  gem.name        = "attributes_dsl"
  gem.version     = AttributesDSL::VERSION.dup
  gem.author      = "Andrew Kozin"
  gem.email       = "andrew.kozin@gmail.com"
  gem.homepage    = "https://github.com/nepalez/attributes_dsl"
  gem.summary     = "Lightweight DSL to define PORO attributes"
  gem.license     = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = Dir["spec/**/*.rb"]
  gem.extra_rdoc_files = Dir["README.md", "LICENSE"]
  gem.require_paths    = ["lib"]

  gem.required_ruby_version = ">= 2.0"

  gem.add_runtime_dependency "equalizer", "~> 0.0.11"
  gem.add_runtime_dependency "transproc", "~> 1.1"

  gem.add_development_dependency "ice_nine", "~> 0.11"
end
