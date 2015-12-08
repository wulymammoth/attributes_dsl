## version 0.1.0 2015-12-08

Stabilized DSL

### Added

* Option `:reader` that allows skipping attribute reader (nepalez)
* Option `:only` whitelists allowed values (nepalez)
* Option `:except` blacklists allowed values (nepalez)
* Option `:coercer` is an alternative to block syntax (nepalez)
* An instance can be initialized by hash with both symbolic and string keys (nepalez)

### Deleted

* Support for rubies < 2.1

### Internal

* Removed freezing of values (nepalez)
* Slightly (20-25%) improved efficiency due to usage of transpfoc (nepalez)

[Compare v0.0.2...v0.1.0](https://github.com/nepalez/attributes_dsl/compare/v0.0.2...v0.1.0)

## version 0.0.2 2015-09-11

This version is a result of applying v0.0.1 to the existing gems:

* [abstract_mapper](https://github.com/nepalez/abstract_mapper)
* [query_builder](https://github.com/nepalez/query_builder)
* [rom-kafka](https://github.com/nepalez/rom-kafka) (WIP)

### Added

* Support for inheritance of attributes (nepalez)

### Bugs fixed

* Allow initializer to be used without arguments (nepalez)
* Allow attributes to be redefined (nepalez)
* Remove `AttributesDSL#new` and move its logics to the initializer (nepalez)

[Compare v0.0.1...v0.0.2](https://github.com/nepalez/attributes_dsl/compare/v0.0.1...v0.0.2)

## version 0.0.1 2015-09-10

This is the first published version
