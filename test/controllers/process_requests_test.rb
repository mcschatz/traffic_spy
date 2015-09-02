require './test/test_helper'

class ProcessRequestsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_it_stores_a_payload
    user = User.create(identifier: 'clarence', root_url: 'clarence.ninja')
    attributes = {:payload => '{"url":"clarence.ninja/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'}
    identifier = user.identifier
    post "/sources/#{identifier}/data", attributes
    assert_equal "clarence.ninja/blog", Request.last.url
    assert_equal 200, last_response.status
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
