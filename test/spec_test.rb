require "test_helper"

describe Autoroku::Spec do
  before do
    @spec = Autoroku::Spec.new("test/resources/api.json")
  end

  it "parses resources" do
    assert_equal 1, @spec.resources.size
    assert_equal "Account", @spec.resources.first.name
  end

  it "parses actions" do
    res    = @spec.resources.first
    action = res.actions.first
    assert_equal 1, res.actions.size
    assert_equal "Update", action.name
    assert_equal "PATCH", action.method
    assert_equal "/account", action.path
    assert_equal 200, action.status
    assert_equal %w( allow_tracking beta email ), action.attributes
  end
end