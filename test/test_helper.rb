require 'minitest/spec'
require 'minitest/autorun'
require 'rr'
require 'webmock/minitest'
require 'autoroku'
require 'autoroku/cli'
require 'autoroku/spec'

class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
end
