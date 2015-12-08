describe "unknown attribute" do
  let(:klass) { Class.new { extend AttributesDSL } }

  subject { klass.new foo: :BAR }

  it "is ignored" do
    expect(subject).not_to respond_to :foo
    expect(subject.attributes).to eql({})
  end
end
