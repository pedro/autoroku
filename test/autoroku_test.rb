require "test_helper"

describe Autoroku do
  before do
    @api = Autoroku.new
    stub_request(:any, %r(https://api.heroku.com/*))
  end

  it "gets account info" do
    @api.account_info
    assert_requested :get, "https://api.heroku.com/account"
  end
end