require "benchmark/ips"

module AttributesDSLExample
  require "attributes_dsl"

  class User
    extend AttributesDSL

    attribute :foo, required: true
    attribute :bar, default: :BAR
    attribute :baz, default: :BAZ
    attribute :qux
  end

  def self.call
    User.new(foo: :FOO, bar: :BAR, baz: :BAZ, qux: :QUX)
  end
end

module VirtusExample
  require "virtus"

  class User
    include Virtus.model

    attribute :foo, String, required: true
    attribute :bar, String, default: :BAR
    attribute :baz, String, default: :BAZ
    attribute :qux, String
  end

  def self.call
    User.new(foo: :FOO, bar: :BAR, baz: :BAZ, qux: :QUX)
  end
end

module ActiveAttrExample
  require "active_attr"

  class User
    include ActiveAttr::MassAssignment
    attr_accessor :foo, :bar, :baz, :qux
  end

  def self.call
    User.new(foo: :FOO, bar: :BAR, baz: :BAZ, qux: :QUX)
  end
end

module FastAttributesExample
  require "fast_attributes"

  class User
    extend FastAttributes

    define_attributes initialize: true do
      attribute :foo, String
      attribute :bar, String
      attribute :baz, String
      attribute :qux, String
    end
  end

  def self.call
    User.new(foo: :FOO, bar: :BAR, baz: :BAZ, qux: :QUX)
  end
end

module AnimaExample
  require "anima"

  class User
    include Anima.new(:foo, :bar, :baz, :qux)
  end

  def self.call
    User.new(foo: :FOO, bar: :BAR, baz: :BAZ, qux: :QUX)
  end
end

module KwattrExample
  require "kwattr"

  class User
    kwattr :foo, :bar, :baz, :qux
  end

  def self.call
    User.new(foo: :FOO, bar: :BAR, baz: :BAZ, qux: :QUX)
  end
end

# Provide a benchmark
Benchmark.ips do |x|
  x.config time: 5, warmup: 5

  x.report("anima") do
    AnimaExample.call
  end

  x.report("kwattr") do
    KwattrExample.call
  end

  x.report("fast_attributes") do
    FastAttributesExample.call
  end

  x.report("attributes_dsl") do
    AttributesDSLExample.call
  end

  x.report("active_attr") do
    AttributesDSLExample.call
  end

  x.report("virtus") do
    VirtusExample.call
  end

  x.compare!
end
