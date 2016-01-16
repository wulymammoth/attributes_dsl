source "https://rubygems.org"

gemspec

group :metrics do
  gem "hexx-suit", "~> 2.3" if RUBY_ENGINE == "ruby" && RUBY_VERSION >= "2.1"
end

group :benchmarks do
  gem "virtus"
  gem "benchmark-ips"
  gem "active_attr"
  gem "fast_attributes"
  gem "anima" if RUBY_VERSION >= "2.1"
  gem "kwattr"
end
