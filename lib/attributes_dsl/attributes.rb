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
    def attributes
      @attributes ||= {}
    end

    # Initializes the attribute from given arguments
    # and returns new immutable collection with the attribute
    #
    # @param (see Attribute#initialize)
    #
    # @return [AttributesDSL::Attributes]
    #
    def add(name, options = {}, &coercer)
      name  = name.to_sym
      value = Attribute.new(name, options, &coercer)
      clone_with do
        @attributes  = attributes.merge(name => value)
        @transformer = nil
      end
    end

    # Returns the proc that converts a hash of attributes using current setting
    #
    # @return [Proc]
    #
    def transformer
      @transformer ||= transprocs.flatten.compact.reduce(:>>)
    end

    # Checks whether an attribute reader should be defined
    #
    # @param [#to_sym] name
    #
    # @return [Boolean]
    #
    def reader?(name)
      attributes[name.to_sym].reader
    end

    private

    def transprocs
      [
        Transprocs[:filter, keys],
        attributes.values.map(&:transformer),
        Transprocs[:update, keys]
      ]
    end

    def keys
      attributes.keys
    end

    def clone_with(&block)
      dup.tap { |instance| instance.instance_eval(&block) }
    end
  end
end
