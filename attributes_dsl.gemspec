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

  gem.required_ruby_version = ">= 1.9.3"

  gem.add_runtime_dependency "ice_nine"
  gem.add_runtime_dependency "equalizer"

  gem.add_development_dependency "hexx-rspec"

end # Gem::Specification
