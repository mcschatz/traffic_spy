require './test/test_helper'

class CreateUserTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_it_creates_a_valid_user
    attributes = {user: {:root_url => "capybara.com", :identifier => "capn"}}
    post '/sources', attributes
    assert_equal 1, User.count
    assert_equal 200, last_response.status
    assert_equal "{\"identifier\":\"capn\"}", last_response.body
  end

  def test_missing_identifier_returns_400_error
    attributes = {user: {:root_url => "capybara"}}
    post '/sources', attributes
    assert_equal 0, User.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_missing_root_url_returns_400_error
    attributes = {user: {:identifier=> "capybara"}}
    post '/sources', attributes
    assert_equal 0, User.count
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end