require_relative '../test_helper'

class ReferralTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = {address: "clarence.ninja"}
    referral = Referral.new(attributes)
    assert_equal "clarence.ninja", referral.address
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end