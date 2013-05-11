require "test_helper"

describe Autoroku::Builder do
  before do
    @spec = Autoroku::Spec.new("test/resources/api.json")
    @builder = Autoroku::Builder.new(
      spec: @spec, name: "autoroku-test", version: "0.0.1")
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

  it "creates a valid gemspec" do
    spec = Gem::Specification.load("build/autoroku-test.gemspec")
    assert_equal "autoroku-test", spec.name
    assert_equal Gem::Version.new("0.0.1"), spec.version
  end

  it "creates api.rb" do
    require "./build/lib/heroku/api.rb"
    assert Heroku::API.new.respond_to?(:account_update)
  end
end