describe "simple attribute" do
  let(:klass) do
    Class.new do
      extend AttributesDSL
      attribute :foo
    end
  end

  it "defines empty attributes" do
    subject = klass.new

    expect(subject.attributes).to eql(foo: nil)
    expect(subject.foo).to be_nil
  end

  it "assigns attributes by symbolic keys" do
    subject = klass.new foo: :BAR

    expect(subject.attributes).to eql(foo: :BAR)
    expect(subject.foo).to eql :BAR
  end

  it "assigns attributes by string keys" do
    subject = klass.new "foo" => :BAR

    expect(subject.attributes).to eql(foo: :BAR)
    expect(subject.foo).to eql :BAR
  end
end
