describe "required attribute" do
  let(:klass) do
    Class.new do
      extend AttributesDSL
      attribute :foo, required: true
      attribute :bar
    end
  end

  it "demands explicit assignment" do
    expect { klass.new bar: :BAZ }.to raise_error(ArgumentError, /foo/)
  end

  it "allows nil values" do
    expect { klass.new foo: nil }.not_to raise_error
  end
end
