Attributes DSL
==============

[![Gem Version](https://img.shields.io/gem/v/attributes_dsl.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/attributes_dsl/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/attributes_dsl.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/attributes_dsl.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/attributes_dsl.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/attributes_dsl.svg)][inch]

Lightweight DSL to define PORO attributes.

Uses immutable (deeply frozen) instances via [ice_nine][ice_nine] gem.

Synopsis
--------

```ruby
require "attributes_dsl"

class User
  extend AttributesDSL

  # `name` is required should be symbolized
  attribute :name, required: true do |value|
    value.to_s.to_sym
  end

  # `sex` is optional and set to `:male` by default.
  # It can be set to either :male or :female
  attribute :sex, default: :male do |value|
    (value == :male )? :male : :female
  end

  # `age` is optional and set to `nil` by default.
  # Then it is converted to integer
  attribute :age, &:to_i

  # `position` is optional and set to `nil` by default
  attribute :position

  # All other attributes are ignored
end

user = User.new(name: "Jane", sex: :women, age: "26", place: "Moscow")
user.attributes
# => { name: :Jane, sex: :female, age: 26, position: nil }

# Aliases for attributes[:some_attribute]
user.name     # => :Jane
user.sex      # => :female
user.age      # => 26
user.position # => nil

# Required attributes should be assigned:
user = User.new(sex: :women, age: "26", place: "Moscow")
# => #<ArgumentError "Undefined attributes: name">
```

Additional Details
------------------

The `attribute` class method takes the `name` and 2 options:
- `:default` for the default value (otherwise `nil`);
- `:required` to declare the attribute as required. It will be ignored if a default value is provided!

It is also takes the block, used to coerce a value. The coercer is applied to the default value too.

Also notice, that instance methods (like `#name`) are just aliases for the corresponding value of the `#attributes` hash. Instance variables aren't defined for them (to ensure syncronization between `#name` and `#attributes[:name]`):

```ruby
user = User.new(name: "John")
user.attributes # => { name: :John, sex: :male, age: 0, position: nil }
user.name # => :John

# but
user.instance_variable_get :@name # => nil
```

You're free to redefine attributes (class settings are used by the initializer only):

```ruby
user.attributes[:name] = "Jim"
user.attributes # => { name: "Jim", sex: :male, age: 0, position: nil }
user.name # => "Jim"
```

But if you (like me) prefer instance immutability, you can deeply freeze instances safely:

```ruby
require "ice_nine"

class User
  # ... staff like before

  def initializer(attributes)
    super
    IceNine.deep_freeze(self)
  end
end

args = { user: "Joe" }

user = User.new(args)
user.frozen?            # => true
user.attributes.frozen? # => true

# "Safely" means:
args.frozen? # => false
```

Freezing instances to exclude side effects is a part of my coding style. That's why the gem doesn't (and won't do) care about changing attributes after initialization.

Benchmarks
----------

The list of gems to compare has been taken from [Idiosyncratic Ruby #18][idiosyncratic_ruby] by Jan Lelis. I've selected only those gems that support initialization from hash.

Look at the [benchmark source][benchmark] for details.

The results are following:

```
-------------------------------------------------
               anima    211.638k (± 3.7%) i/s -      1.071M
              kwattr    187.276k (± 3.6%) i/s -    947.484k
     fast_attributes    160.916k (± 2.4%) i/s -    816.726k
      attributes_dsl     71.850k (± 3.0%) i/s -    365.365k
         active_attr     71.489k (± 3.6%) i/s -    357.995k
              virtus     45.554k (± 7.1%) i/s -    229.338k

Comparison:
               anima:   211637.9 i/s
              kwattr:   187276.2 i/s - 1.13x slower
     fast_attributes:   160916.1 i/s - 1.32x slower
      attributes_dsl:    71850.0 i/s - 2.95x slower
         active_attr:    71489.1 i/s - 2.96x slower
              virtus:    45553.8 i/s - 4.65x slower
```

Results above are pretty reasonable.

The gem is faster than `virtus` that has many additional features.

It is as fast as `active_attrs` (but has more customizable coercers).

It is 2 times slower than `fast_attributes` that has no coercer and default values. And it is 3 times slower than `anima` and `kwattr` that provides only the base settings.

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "attributes_dsl"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install attributes_dsl
```

Compatibility
-------------

Tested under rubies [compatible to MRI 1.9+][versions].

Uses [RSpec][rspec] 3.0+ for testing and [hexx-suit][hexx-suit] for dev/test tools collection.

100% [mutant]-proof covered.

Contributing
------------

* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE)
* [Fork the project](https://github.com/nepalez/attributes_dsl)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
* Run `rake mutant` or `rake exhort` to ensure 100% [mutant][mutant] coverage
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

License
-------

See the [MIT LICENSE](LICENSE).

[codeclimate]: https://codeclimate.com/github/nepalez/attributes_dsl
[coveralls]: https://coveralls.io/r/nepalez/attributes_dsl
[gem]: https://rubygems.org/gems/attributes_dsl
[gemnasium]: https://gemnasium.com/nepalez/attributes_dsl
[travis]: https://travis-ci.org/nepalez/attributes_dsl
[inch]: https://inch-ci.org/github/nepalez/attributes_dsl
[versions]: .travis.yml
[rspec]: http://rspec.org
[hexx-suit]: https://github.com/hexx-rb/hexx-suit
[mutant]: https://github.com/mbj/mutant
[ice_nine]: https://github.com/dkubb/ice_nine
[idiosyncratic_ruby]: http://idiosyncratic-ruby.com/18-con-struct-attributes.html
[benchmark]: benchmark/run.rb
