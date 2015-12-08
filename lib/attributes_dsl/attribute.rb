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

    # @!attribute [r] reader
    #
    # @return [Boolean] whether an attribute should be readable
    #
    attr_reader :reader

    # Initializes the attribute
    #
    # @param [#to_sym] name
    # @param [Hash] options
    # @param [Proc] coercer
    #
    def initialize(name, options = {}, &coercer)
      @name    = name.to_sym
      @options = { coercer: coercer }.merge(options)
      @reader  = @options.fetch(:reader) { true }
    end

    # A proc that transform a hash of attributes using current settings
    #
    # @return [Proc]
    #
    def transformer
      convert unless @options.empty?
    end

    private

    def convert
      @convert ||= Transprocs[:convert, name, presence, absence]
    end

    def presence
      [whitelist, blacklist, coercer].compact.reduce(:>>) || identity
    end

    def absence
      [missed, default].compact.reduce(:>>) || identity
    end

    def identity
      Transprocs[:identity]
    end

    def missed
      Transprocs[:missed, name] if @options[:required]
    end

    def default
      Transprocs[:default, name, @options[:default]] if @options[:default]
    end

    def whitelist
      Transprocs[:whitelist, name, @options[:only]] if @options[:only]
    end

    def blacklist
      Transprocs[:blacklist, name, @options[:except]] if @options[:except]
    end

    def coercer
      Transprocs[:coerce, name, @options[:coercer]] if @options[:coercer]
    end
  end
end
