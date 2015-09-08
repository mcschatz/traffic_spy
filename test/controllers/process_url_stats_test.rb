require './test/test_helper'

class ProcessUrlStatsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_it_finds_all_requests_for_url
    user = User.create(identifier: 'clarence', root_url: 'http://clarence.ninja')
    attributes1 = {:payload => '{"url":"http://clarence.ninja/blog", "respondedIn":"37"}'}
    attributes2 = {:payload => '{"url":"http://clarence.ninja/other_blog", "respondedIn":"38"}'}
    attributes3 = {:payload => '{"url":"http://clarence.ninja/not_a_blog", "respondedIn":"39"}'}
    attributes4 = {:payload => '{"url":"http://clarence.ninja/blog", "respondedIn":"40"}'}
    attributes5 = {:payload => '{"url":"http://clarence.ninja/other_blog", "respondedIn":"41"}'}
    identifier = user.identifier
    post "/sources/#{identifier}/data", attributes1
    post "/sources/#{identifier}/data", attributes2
    post "/sources/#{identifier}/data", attributes3
    post "/sources/#{identifier}/data", attributes4
    post "/sources/#{identifier}/data", attributes5

    get "/sources/#{identifier}/urls/blog"

    assert_equal 200, last_response.status
    assert_equal 5, Request.count
    assert_equal 3, Url.count
    assert_equal "http://clarence.ninja/not_a_blog", Url.last.address
    assert_equal 2, Url.joins(:requests).where(:address => 'http://clarence.ninja/blog').count
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
