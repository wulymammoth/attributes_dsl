# encoding: utf-8

describe AttributesDSL do

  let(:coercer) { -> value { value.to_s } }
  let(:klass) do
    Class.new do
      extend AttributesDSL

      def initialize(attributes)
        super
        IceNine.deep_freeze(self)
      end
    end
  end

  before do
    klass.attribute(:foo, default: :FOO, &:to_s)
    klass.attribute("bar", required: true)
    klass.attribute(:baz, &:to_i)
  end

  subject { klass.new(arguments) }

  context "when all required attributes are set" do
    let(:arguments) { { bar: :BAR, baz: "42" } }

    it "sets the attributes" do
      expect(subject.attributes).to eql(foo: "FOO", bar: :BAR, baz: 42)
    end

    it "defines methods for every attribute" do
      expect(subject.foo).to eql "FOO"
      expect(subject.bar).to eql :BAR
      expect(subject.baz).to eql 42
    end

    it "doesn't freeze argument" do
      expect { subject }.not_to change { arguments.frozen? }
    end
  end # context

  context "when a required attribute is missed" do
    let(:arguments) { { foo: :FOO, baz: "42" } }

    it "fails" do
      expect { subject }.to raise_error ArgumentError
    end
  end # context

end # describe AttributesDSL
