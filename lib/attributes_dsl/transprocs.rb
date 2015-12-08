require "transproc/coercions"

module AttributesDSL
  # The collection of pure composable functions
  #
  module Transprocs
    extend Transproc::Registry

    import :identity, from: Transproc::Coercions

    # Symbolizes hash keys and filters them by given ones
    #
    # @example
    #   filter({ "foo" => :BAR, bar: :BAZ }, [:foo, :qux])
    #   # => { foo: :BAR }
    #
    # @param [Hash] attributes
    # @param [Array] keys
    #
    # @return [Hash] attributes
    #
    def self.filter(attributes, keys)
      attributes
        .map { |key, value| [key.to_sym, value] }
        .select { |key, _| keys.include? key }
        .to_h
    end

    # Ensures all given keys are present in the hash
    #
    # @example
    #   filter({ foo: :BAR }, [:foo, :qux])
    #   # => { foo: :BAR, :qux: nil }
    #
    # @param [Hash] attributes
    # @param [Array] keys
    #
    # @return [Hash]
    #
    def self.update(attributes, keys)
      keys.map { |key| [key, attributes[key]] }.to_h
    end

    # Checks whether the name is present in attributes' keys,
    # and transforms it using either the first or the second procedure
    #
    # @param [Hash] attributes
    # @param [Symbol] name
    # @param [Proc] presence
    # @param [Proc] absence
    #
    # @return [Hash]
    #
    def self.convert(attributes, name, presence, absence)
      if attributes.keys.include? name
        presence[attributes]
      else
        absence[attributes]
      end
    end

    # Complains about missed attribute in a hash
    #
    # @param [Hash] _attributes
    # @param [#to_s] name
    #
    # @return [undefined]
    # @raise [ArgumentError]
    #
    def self.missed(_attributes, name)
      fail ArgumentError.new "Attribute '#{name}' is required"
    end

    # Updates the hash with default name's value
    #
    # @param [Hash] attributes
    # @param [Symbol] name
    # @param [Object] value
    #
    # @return [Hash]
    #
    def self.default(attributes, name, value)
      attributes.merge(name => value)
    end

    # Checks if the attributes has no blacklisted values
    #
    # @param [Hash] attributes
    # @param [Symbol] name
    # @param [Array, Proc, Regexp, Range, Module] condition
    #
    # @return [Hash]
    # @raise [ArgumentError] if the condition is satisfied
    #
    def self.blacklist(attributes, name, condition)
      return attributes unless check(attributes[name], condition)

      fail ArgumentError.new "Attribute #{name} is invalid: #{attributes[name]}"
    end

    # Checks if the attributes has whitelisted values
    #
    # @param [Hash] attributes
    # @param [Symbol] name
    # @param [Array, Proc, Regexp, Range, Module] condition
    #
    # @return [Hash]
    # @raise [ArgumentError] if the condition is NOT satisfied
    #
    def self.whitelist(attributes, name, condition)
      return attributes if check(attributes[name], condition)

      fail ArgumentError.new "Attribute #{name} is invalid: #{attributes[name]}"
    end

    # Coerces attributes' name's value using given proc
    #
    # @example
    #   coerce({ foo: :BAR, bar: :BAZ }, :foo, -> v { v.to_s })
    #   # => { foo: "BAR", bar: :BAZ }
    #
    # @param [Hash] attributes
    # @param [Symbol] name
    # @param [Proc] coercer
    #
    # @return [Hash]
    #
    def self.coerce(attributes, name, coercer)
      attributes.merge(name => coercer[attributes[name]])
    end

    private

    def self.check(value, condition)
      method = condition.is_a?(Array) ? :include? : :===
      condition.send method, value
    rescue
      false
    end
  end
end
