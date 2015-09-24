## version 0.0.3 to be released

### Added

* Option `:reader` that allows skipping attribute reader (nepalez)

### Internal

* Switched to 'immutability' API (nepalez)

[Compare v0.0.2...HEAD](https://github.com/nepalez/attributes_dsl/compare/v0.0.2...HEAD)

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
