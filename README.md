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

  attribute :name, required: true, coerce: -> v { v.to_s }
  attribute :sex,  default: :male, only: /male|female/
  attribute :age,  only: 18..25
  attribute :city, reader: false, except: %w(Moscow)
end

user = User.new(name: :Jane, sex: :female, age: 24, city: "Kiev")
user.attributes
# => { name: :Jane, sex: :female, age: 26, city: "Kiev" }

# Aliases for attributes[:some_attribute]
user.name # => "Jane"
user.sex  # => :female
user.age  # => 26
user.city # => #<NoMethodError ...>
```

Additional Details
------------------

### Attribute declaration

The `attribute` class method takes the `name` and 3 options:

- `:default` for the default value (otherwise `nil`).
- `:required` to declare the attribute as required. It will be ignored if a default value is provided!
- `:reader` defines whether the attribute reader should be defined (`true` by default).
- `:only` defines allowed values. You can use procs (`-> v { v.to_s }`), ranges (`18..25`), regexps (`/male|female/`), constants (`String`), or arrays (`[:male, :female]`) to define a restriction.
- `:except` defines forbidden values.
- `:coercer` defines a procedure to convert assigned value.

It is also takes the block, used to coerce a value. The coercer is applied to the default value too.

### Instance methods

Instance methods (like `#name`) are just aliases for the corresponding value of the `#attributes` hash. Instance variables aren't defined for them (to ensure syncronization between `#name` and `#attributes[:name]`):

```ruby
user = User.new(name: "John")
user.attributes # => { name: :John, sex: :male, age: nil, city: nil }

user.name # => :John
user.instance_variable_get :@name # => nil
```

### Inheritance

Subclasses inherits attributes of the superclass:

```ruby
class UserWithRole < User
  attribute :role, default: :user
end

user = UserWithRole.new(name: "Sam")
user.attributes
user.attributes
# => { name: :John, sex: :male, age: nil, city: nil, role: :user }
```

### Undefining Attributes

This feature is not available (and it won't be).

The reason is that a subclass should satisfy a contract of its superclass, including the existence of attributes, declared by the superclass.
All you can do is reload attribute definition in a subclass:

```ruby
class Person < User
  attribute :name, &:to_s
end

user = Person.new(name: :Sam)
user.attributes
# => { name: "Sam", sex: :male, age: 0, position: nil }
```

### Freezing

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
              kwattr:   183416.9 i/s
               anima:   169647.3 i/s - 1.08x slower
     fast_attributes:   156036.2 i/s - 1.18x slower
      attributes_dsl:    74495.9 i/s - 2.46x slower
         active_attr:    74469.4 i/s - 2.46x slower
              virtus:    46587.0 i/s - 3.94x slower
```

Results above are pretty reasonable.

The gem is faster than `virtus` that has many additional features.

It is as fast as `active_attrs` (but has more options).

It is 2 times slower than `fast_attributes` that has no coercer and default values. And it is 2.5 times slower than `anima` and `kwattr` that provide only simple attribute's declaration.

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

Tested under rubies compatible to [MRI 2.0+][versions].

Uses [RSpec][rspec] 3.0+ for testing and [hexx-suit][hexx-suit] for dev/test tools collection.

Contributing
------------

* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE)
* [Fork the project](https://github.com/nepalez/attributes_dsl)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
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
