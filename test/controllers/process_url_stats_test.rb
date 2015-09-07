require './test/test_helper'

class ProcessUrlStatsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  # def test_it_finds_all_requests_for_url
  #   user = User.create(identifier: 'clarence', root_url: 'http://clarence.ninja')
  #   attributes = {:payload => '{"url":"http://clarence.ninja/blog", "respondedIn":"37"}'}
  #   identifier = user.identifier
  #   post "/sources/#{identifier}/data", attributes
  #
  #   get "/sources/#{identifier}/urls/blog"
  #
  #   assert_equal 1, Request.last.user_id
  #   assert_equal "clarence.ninja/blog", Url.last.address
  #   assert_equal 200, last_response.status
  # end



  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
