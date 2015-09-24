# encoding: utf-8

describe AttributesDSL::Attributes do

  let(:attributes) { described_class.new }
  let(:coercer)    { -> value { value.to_s } }

  describe ".new" do
    subject { attributes }

    it { is_expected.to be_immutable }
  end # describe .new

  describe "#attributes" do
    subject { attributes.attributes }

    it { is_expected.to be_kind_of Hash }
    it { is_expected.to be_empty }
  end # describe #attributes

  describe "#register" do
    subject do
      attributes.register(:bar).register(:foo, default: :FOO, &coercer)
    end

    it "returns new collection" do
      expect(subject).to be_kind_of described_class
    end

    it "adds attributes" do
      expect(subject.attributes.keys).to contain_exactly(:bar, :foo)
    end

    it "uses arguments" do
      attribute = subject.attributes[:foo]

      expect(attribute).to be_kind_of AttributesDSL::Attribute
      expect(attribute.name).to eql :foo
      expect(attribute.default).to eql :FOO
      expect(attribute.coercer).to eql coercer
    end

    context "without options" do
      subject { attributes.register :foo }

      it { is_expected.to be_kind_of described_class }
    end
  end # describe #register

  describe "#extract" do
    subject { attributes.extract hash }

    let(:hash) { { bar: :BAR } }
    let(:attributes) do
      described_class
        .new
        .register(:foo, required: true, &coercer)
        .register(:bar, required: true)
        .register(:baz, default: :BAZ, &coercer)
    end

    context "when all required attributes are present" do
      let(:hash) { { foo: :FOO, bar: :BAR, qux: :QUX } }

      it "returns a proper hash" do
        expect(subject).to eql(foo: "FOO", bar: :BAR, baz: "BAZ")
      end
    end

    context "when a required attribute is absent" do
      let(:hash) { { baz: :BAZ } }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of ArgumentError
          expect(error.message).to eql "Undefined attributes: foo, bar"
        end
      end
    end
  end # describe #extract

end # describe AttributeDSL::Attributes
