require "test_helper"

describe Autoroku::Builder do
  before do
    $build_only_once ||= begin
      @spec = Autoroku::Spec.new("test/resources/api.json")
      @builder = Autoroku::Builder.new(
        spec: @spec, name: "autoroku-test", version: "0.0.1")
      @builder.run
    end
  end

  it "creates a build folder" do
    assert File.exists?("build")
  end

  it "creates README.md" do
    readme = File.read("build/README.md")
    assert readme.include?("Heroku.rb"), "includes header"
    assert readme.include?("Foo Bar"),   "includes resource info"
  end

  it "creates a Gemfile" do
    assert_equal File.read("template/Gemfile"), File.read("build/Gemfile")
  end

  it "creates a valid gemspec" do
    spec = Gem::Specification.load("build/autoroku-test.gemspec")
    assert_equal "autoroku-test", spec.name
    assert_equal Gem::Version.new("0.0.1"), spec.version
  end

  it "creates main rb file for the gem" do
    assert_equal File.read("template/heroku-api.rb"),
      File.read("build/lib/autoroku-test.rb")
  end

  describe "generated API" do
    before do
      @path = "./build/lib/heroku/api.rb"
      require @path
      @api = Heroku::API.new
      stub_request(:any, %r{https://api.heroku.com/foo-bar*})
    end

    it "defines methods after the actions" do
      assert @api.respond_to?(:foo_bar_create), "responds to foo_bar_update"
    end

    it "requires params" do
      lambda { @api.foo_bar_create }.must_raise ArgumentError
    end

    it "identifies invalid params" do
      lambda { @api.foo_bar_create(wrong: true) }.must_raise ArgumentError
    end

    it "enforces required params" do
      lambda { @api.foo_bar_create(r1: "foo") }.must_raise ArgumentError
    end

    it "makes a request according to the spec" do
      @api.foo_bar_create(r1: "foo", r2: "bar")
      assert_requested(:post, "https://api.heroku.com/foo-bar",
        query: { r1: "foo", r2: "bar" })
    end

    it "comments on the method signature" do
      assert File.read(@path).include?("# POST /foo-bar")
    end

    it "extracts ids from the path" do
      @api.foo_bar_update(42, r1: "foo")
      assert_requested(:patch, "https://api.heroku.com/foo-bar/42",
        query: { r1: "foo" })
    end
  end
end