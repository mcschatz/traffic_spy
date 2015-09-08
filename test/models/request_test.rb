require_relative '../test_helper'

class RequestTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = {user_id: 1,
                  url_id: 2,
                  referral_id: 3,
                  type_id: 4,
                  event_id: 5,
                  operating_system_id: 6,
                  browser_id: 7,
                  resolution_id: 8,
                  requested_at: DateTime.new(2015),
                  response_time: 11,
                  sha: 12}
    request = Request.create(attributes)

    assert_equal 1, request.user_id
    assert_equal 2, request.url_id
    assert_equal 3, request.referral_id
    assert_equal 4, request.type_id
    assert_equal 5, request.event_id
    assert_equal 6, request.operating_system_id
    assert_equal 7, request.browser_id
    assert_equal 8, request.resolution_id
    assert_equal "2015-01-01T00:00:00+00:00", request.requested_at.to_s
    assert_equal DateTime, request.requested_at.class
    assert_equal 11, request.response_time
    assert_equal "12", request.sha
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end