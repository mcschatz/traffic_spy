require_relative '../test_helper'

class UserTest < ModelTest
  def setup
    super
    create_user
    create_user_requests
  end

  def test_it_assigns_proper_attributes
    assert_equal "jumpstartlab", User.first.identifier
    assert_equal "http://jumpstartlab.com", User.first.root_url
  end
end