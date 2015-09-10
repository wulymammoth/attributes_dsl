# encoding: utf-8

module AttributesDSL

  # Describes a collection of attributes declaration with methods
  # to validate and extract instance attributes from a hash.
  #
  # @api private
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  class Attributes

    # @!attribute [r] attributes
    #
    # Uses the set of attributes to ensure their uniqueness (by name)
    #
    # @return [Set] the set of registered attributes
    #
    attr_reader :attributes

    # Initializes an immutable collection with an initial set of attributes
    #
    # @param [Hash] attributes
    #
    def initialize(attributes = {})
      @attributes = attributes
      IceNine.deep_freeze(self)
    end

    # Initializes the attribute from given arguments
    # and returns new immutable collection with the attribute
    #
    # @param (see Attribute#initialize)
    #
    # @return [AttributesDSL::Attributes]
    #
    def register(name, options = {}, &coercer)
      self.class.new(
        attributes.merge(name => Attribute.new(name, options, &coercer))
      )
    end

    # Extracts instance attributes from the input hash
    #
    # Assigns default values and uses coercions when applicable.
    #
    # @param [Hash] input
    #
    # @return [Hash]
    #
    def extract(input)
      validate(input).inject({}) do |a, e|
        key = e.name
        value = input.fetch(key) { e.default }
        a.merge(key => e.value(value))
      end
    end

    private

    def validate(input)
      undefined = required - input.keys
      return attributes.values if undefined.empty?

      fail ArgumentError.new "Undefined attributes: #{undefined.join(", ")}"
    end

    def required
      attributes.values.select(&:required).map(&:name)
    end

  end # class Attributes

end # module AttributesDSL
