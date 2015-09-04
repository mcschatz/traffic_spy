require_relative '../test_helper'

class UserTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = {identifier: "jumpstartlab", root_url: "jumpstartlab.com"}
    user = User.new(attributes)
    assert_equal "jumpstartlab", user.identifier
    assert_equal "jumpstartlab.com", user.root_url
  end
end