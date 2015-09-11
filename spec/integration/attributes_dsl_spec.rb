# encoding: utf-8

describe AttributesDSL do

  let(:coercer) { -> value { value.to_s } }
  let(:klass) { Class.new { extend AttributesDSL } }

  before do
    klass.attribute(:foo, &:to_s)
    klass.attribute("bar")
    klass.attribute(:baz, &:to_i)
  end

  subject { klass.new(arguments) }

  describe "instance" do

    context "without arguments" do
      subject { klass.new }

      it "initializes default attributes" do
        expect(subject.attributes).to eql(foo: "", bar: nil, baz: 0)
      end
    end

    context "when all required attributes are set" do
      let(:arguments) { { bar: :BAR, baz: "42" } }
      let(:klass) do
        Class.new do
          extend AttributesDSL

          def initialize(attributes = {})
            super
            IceNine.deep_freeze(self)
          end
        end
      end

      it "initializes attributes" do
        expect(subject.attributes).to eql(foo: "", bar: :BAR, baz: 42)
      end

      it "defines methods for every attribute" do
        expect(subject.foo).to eql ""
        expect(subject.bar).to eql :BAR
        expect(subject.baz).to eql 42
      end

      it "doesn't freeze argument" do
        expect { subject }.not_to change { arguments.frozen? }
      end
    end

    context "when a required attribute is missed" do
      let(:arguments) { { foo: :FOO, baz: "42" } }

      before { klass.attribute("bar", required: true) }

      it "fails" do
        expect { subject }.to raise_error ArgumentError
      end
    end

  end # describe instance

  describe "subclass" do

    subject { Class.new(klass) }

    it "inherits parent attributes" do
      expect(subject.new.attributes).to eql(klass.new.attributes)
    end

  end # describe subclass

end # describe AttributesDSL
