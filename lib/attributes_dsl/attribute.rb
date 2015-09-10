# encoding: utf-8

module AttributesDSL

  # Describes settings for PORO attribute
  #
  # @api private
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  class Attribute

    include Equalizer.new(:name)

    # @!attribute [r] name
    #
    # @return [Symbol] the name of the attribute
    #
    attr_reader :name

    # @!attribute [r] default
    #
    # @return [Object] the default value of the attribute
    #
    attr_reader :default

    # @!attribute [r] required
    #
    # @return [Boolean] whether the attribute is required
    #
    attr_reader :required

    # @!attribute [r] coercer
    #
    # @return [Proc, nil] the coercer for the attribute
    #
    attr_reader :coercer

    # Initializes the attribute
    #
    # @param [Symbol] name
    # @param [Hash] options
    # @param [Proc] coercer
    #
    # @option options [Object] :default
    # @option options [Boolean] :required
    #
    def initialize(name, options = {}, &coercer)
      @name = name
      @default = options.fetch(:default) {}
      @required = default.nil? && options.fetch(:required) { false }
      @coercer = coercer

      IceNine.deep_freeze(self)
    end

    # Coerces an input assigned to the attribute
    #
    # @param [Object] input
    #
    # @return [Object]
    #
    def value(input)
      coercer ? coercer[input] : input
    end

  end # class Attribute

end # module AttributesDSL
