describe "required attribute" do
  let(:klass) do
    Class.new do
      extend AttributesDSL
      attribute :foo, default: :FOO
    end
  end

  it "adds default assignment" do
    subject = klass.new

    expect(subject.foo).to eql :FOO
  end

  it "assigns explicit value" do
    subject = klass.new foo: :BAR

    expect(subject.foo).to eql :BAR
  end
end
