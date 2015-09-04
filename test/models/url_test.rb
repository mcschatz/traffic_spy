require_relative '../test_helper'

class UrlTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = {address: "www.clarence.ninja"}
    url = Url.new(attributes)
    assert_equal "www.clarence.ninja", url.address
  end
end