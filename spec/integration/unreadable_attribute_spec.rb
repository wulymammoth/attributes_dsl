describe "unreadable attribute" do
  let(:klass) do
    Class.new do
      extend AttributesDSL
      attribute :foo, reader: false
    end
  end

  subject { klass.new foo: :BAR }

  it "defines the attribute" do
    expect(subject.attributes).to eql(foo: :BAR)
  end

  it "doesn't define a reader" do
    expect(subject).not_to respond_to :foo
  end
end
