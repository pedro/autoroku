require "test_helper"

describe Autoroku::Spec do
  before do
    @api  = {
      "resources" => {
        "Account" => {
          "actions" => {
            "Update" => {
              "method" => "PATCH",
              "path"   => "/account",
              "status" => "200 OK",
              "attributes" => {
                "optional" => %w( allow_tracking beta email )
              }
            }
          }
        }
      }
    }
    @spec = Autoroku::Spec.new(@api)
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