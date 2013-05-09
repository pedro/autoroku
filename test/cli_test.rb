require "test_helper"

describe Autoroku::CLI do
  before do
    @cli = Autoroku::CLI.new
    stub_request(:any, %r(https://api.heroku.com/*)).
      to_return(:body => Yajl::Encoder.encode("foo" => "bar"))
    stub(@cli).display(anything)
  end

  it "displays account info" do
    mock(@cli).display("foo: bar")
    @cli.run ["account:info"]
  end
end