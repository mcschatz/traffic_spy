require_relative '../test_helper'

class UserCanSeeDashboardTest < FeatureTest
  def test_user_can_see_all_registered_sites
    visit '/'
    assert page.has_content?("clarence")
    assert page.has_content?("zombo")
  end

  def test_user_can_see_specific_user_details
    visit '/'
    click_link("clarence")
    assert page.has_content?("http://clarence.ninja/blog")
    assert page.has_content?("Firefox")
    assert page.has_content?("OpenBSD")
    assert page.has_content?("1920 x 1280")
    assert page.has_content?("http://clarence.ninja/blog: 37")
  end

  def test_user_gets_an_error_page_for_invalid_identifier
    visit '/sources/timothy'
    assert page.has_content?("The requested user, timothy, is not registered.")
  end

  def test_user_can_see_url_specific_details
    visit '/'
    click_link("clarence")
    first(:link,"http://clarence.ninja/blog").click
    assert_equal "/sources/clarence/urls/blog", current_path
    # require 'pry'; binding.pry
    assert page.has_content?("37")
    assert page.has_content?("OpenBSD")
    assert page.has_content?("Firefox")
    assert page.has_content?("GET")
    assert page.has_content?("http://www.google.com")
  end

  def test_user_can_see_event_index
    visit '/'
    click_link("clarence")
    click_on("Events")
    assert_equal "/sources/clarence/events", current_path
    assert page.has_content?("tubbin")
  end

  def test_user_can_see_event_specific_details
    visit '/'
    click_link("clarence")
    click_on("Events")
    click_link("tubbin")
    assert_equal "/sources/clarence/events/tubbin", current_path
    assert page.has_content("tubbin")
    assert page.has_content("9:00 PM - 1")
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
                   sha: 40823)
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
