require_relative '../test_helper'

class RequestTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = {user_id: 1,
                  url_id: 2,
                  # referred_by_id: 3,
                  # request_type_id: 4,
                  # event_id: 5,
                  operating_system_id: 6,
                  browser_id: 7,
                  resolution_id: 8,
                  # ip_id: 9,
                  # requested_at: 10,
                  # responded_in: 11,
                  sha: 12}
    request = Request.create(attributes)
    
    assert_equal 1, request.user_id
    assert_equal 2, request.url_id
    # assert_equal "Chrome", request.referred_by_id
    # assert_equal "Chrome", request.request_type_id
    # assert_equal "Chrome", request.event_id
    assert_equal 6, request.operating_system_id
    assert_equal 7, request.browser_id
    assert_equal 8, request.resolution_id
    # assert_equal "Chrome", request.ip_id
    # assert_equal "Chrome", request.request_at
    # assert_equal "Chrome", request.responded_in
    assert_equal "12", request.sha
  end
end