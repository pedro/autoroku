require "test_helper"

describe Autoroku::Builder do
  before do
    @spec = Autoroku::Spec.new("test/resources/api.json")
    @builder = Autoroku::Builder.new(@spec)
    @builder.run
  end

  it "creates a build folder" do
    assert File.exists?("build")
  end

  it "creates README.md" do
    readme = File.read("build/README.md")
    assert readme.include?("Heroku.rb"), "includes header"
    assert readme.include?("Account"),   "includes resource info"
  end

  it "creates a Gemfile" do
    assert_equal File.read("template/Gemfile"), File.read("build/Gemfile")
  end
end