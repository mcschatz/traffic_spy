require_relative '../test_helper'

class UserTest < ModelTest
  def test_it_assigns_proper_attributes
    assert_equal "jumpstartlab", User.first.identifier
    assert_equal "http://jumpstartlab.com", User.first.root_url
  end

  def test_user_dashboard_returns_url_info
    user = User.first
    assert_equal "http://jumpstartlab.com/blog",
    User.stats(user)[:url_info].first[:description]
  end

  def test_user_dashboard_returns_browser_info
    user = User.first
    assert_equal "Chrome",
    User.stats(user)[:browser_info].first[:description]
  end

  def test_user_dashboard_returns_os_info
    user = User.first
    assert_equal "Macintosh%3B Intel Mac OS X 10_8_2",
    User.stats(user)[:os_info].first[:description]
  end

  def test_user_dashboard_returns_resolution_info
    user = User.first
    assert_equal "800 x 600",
    User.stats(user)[:resolution_info].first[:description]
  end

  def test_user_dashboard_returns_sorted_avg_response_times_by_url
    user = User.first
    assert_equal "http://jumpstartlab.com/blog",
    User.stats(user)[:sorted_avg_response_times_by_url].first[:address]
    assert_equal 148.67,
    User.stats(user)[:sorted_avg_response_times_by_url].first[:ave_response_time]
    assert_equal "http://jumpstartlab.com",
    User.stats(user)[:sorted_avg_response_times_by_url].last[:address]
    assert_equal 37.0,
    User.stats(user)[:sorted_avg_response_times_by_url].last[:ave_response_time]
  end

  def test_user_counts_events_by_hour
    user = User.first
    assert_equal [4.0, 1], user.event_count_by_hour(user, "socialLogin").first
  end

  def setup
    DatabaseCleaner.start
    super
    create_user
    create_user_requests
  end

  def teardown
    DatabaseCleaner.clean
  end
end