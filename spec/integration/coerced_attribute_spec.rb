describe "coerced attribute" do
  let(:klass) do
    Class.new do
      extend AttributesDSL
      attribute :foo, coercer: -> v { v.to_s }
      attribute :bar, &:to_s
    end
  end

  it "is not applied to skipped value" do
    subject = klass.new

    expect(subject.foo).to be_nil
  end

  it "is applied to assigned value" do
    subject = klass.new foo: nil

    expect(subject.foo).to eql("")
  end

  it "can be defined via block" do
    subject = klass.new bar: :BAZ

    expect(subject.bar).to eql("BAZ")
  end
end
