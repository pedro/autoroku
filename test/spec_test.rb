require "test_helper"

describe Autoroku::Spec do
  before do
    @spec = Autoroku::Spec.new("test/resources/api.json")
  end

  it "parses resources" do
    assert_equal 1, @spec.resources.size
    assert_equal "Foo Bar", @spec.resources.first.name
  end

  it "parses actions" do
    res    = @spec.resources.first
    action = res.actions.first
    assert_equal 1, res.actions.size
    assert_equal "Update", action.name
    assert_equal "PATCH", action.method
    assert_equal "/foo-bar", action.path
    assert_equal 200, action.status
    assert_equal %w( r1 r2 o1 ), action.attributes.map(&:name)
    assert_equal [true, true, false], action.attributes.map(&:required)
  end
end