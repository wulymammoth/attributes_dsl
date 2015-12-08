describe "whitelisted attribute" do
  let(:substring) { Class.new(String) }
  let(:klass) do
    Class.new do
      extend AttributesDSL

      attribute :foo, only: /foo/
      attribute :bar, only: 1..3
      attribute :baz, only: %w(foo bar)
      attribute :qux, only: -> v { v.even? }
      attribute :yux, only: String
      attribute :fix, only: String, coercer: -> v { v.to_s }
    end
  end

  it "doesn't check unassigned values" do
    expect { klass.new }.not_to raise_error
  end

  it "passes when all values are valid" do
    params = { foo: "foo", bar: 2, baz: "foo", qux: 2, yux: "1", fix: "2" }

    expect { klass.new params }.not_to raise_error
  end

  it "checks regexp condition" do
    expect { klass.new foo: "bar" }.to raise_error(ArgumentError, /foo/)
  end

  it "checks range condition" do
    expect { klass.new bar: 4 }.to raise_error(ArgumentError, /bar/)
  end

  it "checks array condition" do
    expect { klass.new baz: "qux" }.to raise_error(ArgumentError, /baz/)
  end

  it "checks proc condition" do
    expect { klass.new qux: 3 }.to raise_error(ArgumentError, /qux/)
  end

  it "checks type" do
    expect { klass.new yux: :foo }.to raise_error(ArgumentError, /yux/)
  end

  it "applies validation before coersion" do
    expect { klass.new fix: :foo }.to raise_error(ArgumentError)
  end
end
