# encoding: utf-8

require "equalizer"
require "immutability"

# Simple DSL for PORO attributes
#
# @api public
#
# @author Andrew Kozin <Andrew.Kozin@gmail.com>
#
module AttributesDSL

  require_relative "attributes_dsl/attribute"
  require_relative "attributes_dsl/attributes"

  # The mutable collection of declared attributes
  #
  # @return [AttributeDSL::Attributes]
  #
  # @api private
  #
  def attributes
    @attributes ||= Attributes.new
  end

  # Retisters an attribute by name, options and coercer
  #
  # @example
  #   class MyClass
  #     extend AttributeDSL
  #
  #     attribute :foo, required: true do |value|
  #       value.to_i % 5 # value coercer
  #     end
  #
  #     attribute :bar, default: :BAR, reader: false
  #   end
  #
  # @param [#to_sym] name The unique name of the attribute
  # @param [Proc] coercer The proc to coerce values (including the default ones)
  # @param [Hash] options
  #
  # @option options [Boolean] :required
  #   Whether the attribute should be required by the +initializer+
  #   This option is ignored (set to +false+) when default value is provided
  # @option options [Object] :default
  #   The default value for the attribute
  # @option options [Boolean] :reader (true)
  #   Whether the attribute reader should be added
  #
  # @return [undefined]
  #
  def attribute(name, options = {}, &coercer)
    s_name = name.to_sym
    @attributes = attributes.register(s_name, options, &coercer)

    return unless options.fetch(:reader) { true }
    define_method(s_name) { attributes.fetch(s_name) }
  end

  # @private
  def self.extended(klass)
    klass.instance_eval { include InstanceMethods }
  end

  # @private
  def inherited(klass)
    klass.instance_variable_set(:@attributes, attributes)
  end

  # Defines instance methods for the hash of attributes and its initializer
  module InstanceMethods

    # @!attribute [r] attributes
    #
    # @return [Hash] the hash of initialized attributes
    #
    attr_reader :attributes

    # Initializes the object and sets the hash of its [#attributes]
    #
    # @param [Hash] attributes
    #
    # @raise [ArgumentError] in case a required attribute is missed
    #
    def initialize(attributes = {})
      @attributes = self.class.attributes.extract(attributes)
    end

  end # module InstanceMethods

end # module AttributesDSL
