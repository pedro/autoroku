require "test_helper"

describe Autoroku do
  before do
    @api = Autoroku.new
    stub_request(:any, %r(https://api.heroku.com/*))
  end

  it "gets account info" do
    stub_request(:get, "https://api.heroku.com/account").
      to_return(:body => Yajl::Encoder.encode("foo" => "bar"))
    @api.account_info.must_equal("foo" => "bar")
  end

  it "updates accounts" do
    @api.account_update(allow_tracking: false)
    assert_requested(:patch, "https://api.heroku.com/account",
      :query => { allow_tracking: false })
  end
end