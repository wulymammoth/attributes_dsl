# encoding: utf-8

describe AttributesDSL::Attribute do

  let(:attribute) do
    described_class.new(name, default: default, required: required, &coercer)
  end

  let(:name)     { :foo }
  let(:default)  { "FOO" }
  let(:required) { true }
  let(:coercer)  { -> v { v.to_s } }

  describe ".new" do
    subject { attribute }

    it { is_expected.to be_immutable }
  end # describe .new

  describe "#name" do
    subject { attribute.name }

    it { is_expected.to eql name.to_sym }
  end # describe #name

  describe "#default" do
    subject { attribute.default }

    context "when value is given" do
      it { is_expected.to eql default }
    end

    context "when value isn't set" do
      let(:attribute) { described_class.new name }

      it { is_expected.to be_nil }
    end
  end # describe #default

  describe "#required" do
    subject { attribute.required }

    context "when set to true without default value" do
      let(:attribute) { described_class.new name, required: true }

      it { is_expected.to eql true }
    end

    context "when set to true with default value" do
      let(:attribute) { described_class.new name, required: true, default: 1 }

      it { is_expected.to eql false }
    end

    context "when value isn't set" do
      let(:attribute) { described_class.new name }

      it { is_expected.to eql false }
    end
  end # describe #required

  describe "#coercer" do
    subject { attribute.coercer }

    context "when block is given" do
      it { is_expected.to eql coercer }
    end

    context "when block isn't given" do
      let(:attribute) { described_class.new name }

      it { is_expected.to be_nil }
    end
  end # describe #coercer

  describe "#value" do
    subject { attribute.value(1) }

    context "when coercer is given" do
      it "uses the coercer" do
        expect(subject).to eql "1"
      end
    end

    context "when coercer isn't given" do
      let(:attribute) { described_class.new name }

      it "returns the input" do
        expect(subject).to eql 1
      end
    end
  end # describe #value

  describe "#==" do
    subject { attribute == other }

    context "with the same name" do
      let(:other) { described_class.new name }

      it { is_expected.to eql true }
    end

    context "with another name" do
      let(:other) { described_class.new :bar }

      it { is_expected.to eql false }
    end
  end # describe #==

  describe "#eql?" do
    subject { attribute.eql? other }

    context "with the same name" do
      let(:other) { described_class.new name }

      it { is_expected.to eql true }
    end

    context "with another name" do
      let(:other) { described_class.new :bar }

      it { is_expected.to eql false }
    end
  end # describe #eql?

end # describe AttributesDSL::Attribute
