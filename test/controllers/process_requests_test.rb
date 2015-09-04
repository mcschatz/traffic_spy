require './test/test_helper'

class ProcessRequestsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_it_stores_a_payload
    user = User.create(identifier: 'clarence', root_url: 'clarence.ninja')
    attributes = {:payload => '{"url":"clarence.ninja/blog"}'}
    identifier = user.identifier
    post "/sources/#{identifier}/data", attributes

    assert_equal 1, Request.last.user_id
    assert_equal "clarence.ninja/blog", Url.last.address
    assert_equal 200, last_response.status
  end

  def test_it_returns_a_400_bad_request_if_payload_is_missing
    user = User.create(identifier: 'clarence', root_url: 'clarence.ninja')
    attributes = {}
    identifier = user.identifier
    post "/sources/#{identifier}/data", attributes

    assert_equal 400, last_response.status
    assert_equal "Missing the payload", last_response.body.chomp
  end

  def test_it_returns_a_403_forbidden_if_payload_already_exists
    user = User.create(identifier: 'clarence', root_url: 'clarence.ninja')
    attributes1 = {:payload => '{"url":"clarence.ninja/blog"}'}
    attributes2 = {:payload => '{"url":"clarence.ninja/about"}'}

    identifier = user.identifier

    post "/sources/#{identifier}/data", attributes1
    post "/sources/#{identifier}/data", attributes1
    assert_equal 403, last_response.status
    assert_equal 'This request has already been recorded.', last_response.body.chomp
    post "/sources/#{identifier}/data", attributes2
    assert_equal 200, last_response.status
    assert_equal 2, Request.count

  end

  def test_it_returns_a_403_forbidden_if_url_does_not_belong_to_the_given_user
    user = User.create(identifier: 'clarence', root_url: 'clarence.ninja')
    attributes = {:payload => '{"url":"clarence.com/blog"}'}
    identifier = user.identifier

    post "/sources/#{identifier}/data", attributes

    assert_equal 403, last_response.status
    assert_equal "This application is not registered to this user.", last_response.body.chomp
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
