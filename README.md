AttributesDSL
===================

[![Gem Version](https://img.shields.io/gem/v/attributes_dsl.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/attributes_dsl/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/attributes_dsl.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/attributes_dsl.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/attributes_dsl.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/attributes_dsl.svg)][inch]

@todo: describe the module

Synopsis
--------

@todo Describe the base use

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

Tested under rubies [compatible to MRI 1.9+][travis].

Uses [RSpec][rspec] 3.0+ for testing and [hexx-suit][hexx-suit] for dev/test tools collection.

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
[travis]: .travis.yml
[rspec]: http://rspec.org
[hexx-suit]: https://github.com/hexx-rb/hexx-suit
[mutant]: https://github.com/mbj/mutant
