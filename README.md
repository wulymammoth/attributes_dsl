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

The list of gems to compare has been taken from [Idiosyncratic Ruby #18][idiosyncratic_ruby] by Jan Lelis. Look at the [benchmark example][benchmakrs] for details. I've selected only those gems that support initialization from hash:

```
-------------------------------------------------
               anima    202.863k (± 5.1%) i/s -      1.023M
              kwattr    171.461k (± 5.3%) i/s -    855.680k
     fast_attributes    156.596k (± 2.5%) i/s -    785.792k
      attributes_dsl     58.966k (± 4.6%) i/s -    296.514k
         active_attr     58.322k (± 2.8%) i/s -    293.205k
              virtus     45.734k (± 2.7%) i/s -    228.960k

Comparison:
               anima:   202862.9 i/s
              kwattr:   171460.9 i/s - 1.18x slower
     fast_attributes:   156596.3 i/s - 1.30x slower
      attributes_dsl:    58966.5 i/s - 3.44x slower
         active_attr:    58321.6 i/s - 3.48x slower
              virtus:    45734.3 i/s - 4.44x slower
```

Results above are pretty reasonable.

The gem is faster than `virtus` that has many additional features.

It is as fast as `active_attrs` (but has more customizable coercers).

It is 2 times slower than `fast_attributes` that has no coercer and default values. And it is 3-3.5 times slower than `anima` and `kwattr` that provides only the base settings.

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
