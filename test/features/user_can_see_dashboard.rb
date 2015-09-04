require_relative '../test_helper'

class UserCanSeeDashboardTest < FeatureTest
  def test_user_can_see_all_registered_sites
    visit '/'
    assert page.has_content?("clarence")

    click_link("clarence")
    assert page.has_content?("http://clarence.ninja/blog")
    assert page.has_content?("Firefox")
    assert page.has_content?("OpenBSD")
    assert page.has_content?("1920 x 1280")
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
  end

  def setup
    DatabaseCleaner.start

    User.create(identifier: 'clarence', root_url: 'clarence.ninja')
    Request.create(user_id: 1,
                   url_id: 1,
                   browser_id: 1,
                   operating_system_id: 1,
                   resolution_id: 1,
                   response_time: 37,
                   sha: 40823)
    Url.create(address: "http://clarence.ninja/blog")
    Browser.create(name: "Firefox")
    OperatingSystem.create(name: "OpenBSD")
    Resolution.create(description: "1920 x 1280")
  end

  def teardown
    DatabaseCleaner.clean
  end
end
