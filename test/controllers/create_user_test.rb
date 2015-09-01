require './test/test_helper'

class CreateUserTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_it_creates_a_valid_user
    attributes = {user: {:root_url => "capybara.com", :identifier => "capn"}}
    require 'pry'; binding.pry
    post '/sources', attributes
    assert_equal 1, User.count
    assert_equal 200, last_response.status
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end