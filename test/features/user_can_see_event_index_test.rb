require_relative '../test_helper'

class UserCanSeeEventIndexTest < FeatureTest
  def test_user_can_see_event_index
    visit '/'
    click_link("Clarence")
    click_on("Events")
    assert_equal "/sources/clarence/events", current_path
    assert page.has_content?("tubbin")
  end

  def test_user_sees_an_error_if_there_are_no_events
    visit '/'
    click_link("Zombo")
    click_on("Events")
    assert_equal "/sources/zombo/events", current_path
    assert page.has_content?("There are no events for this user")
  end

  def setup
    DatabaseCleaner.start

    User.create(identifier: 'clarence', root_url: 'http://clarence.ninja')
    Request.create(user_id: 1,
                   url_id: 1,
                   browser_id: 1,
                   operating_system_id: 1,
                   resolution_id: 1,
                   referral_id: 1,
                   type_id: 1,
                   event_id: 1,
                   response_time: 37,
                   requested_at: "2013-01-14 21:38:28 -0700",
                   sha: "40823")
    Url.create(address: "http://clarence.ninja/blog")
    Browser.create(name: "Firefox")
    OperatingSystem.create(name: "OpenBSD")
    Resolution.create(description: "1920 x 1280")
    Referral.create(address: "http://www.google.com")
    Type.create(name: "GET")
    Event.create(name: "tubbin")
    User.create(identifier: 'zombo', root_url: 'zombo.com')
  end

  def teardown
    DatabaseCleaner.clean
  end
end
