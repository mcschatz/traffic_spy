require_relative '../test_helper'

class UserCanSeeUrlDetailsTest < FeatureTest
  def test_user_can_see_url_specific_details
    visit '/'
    click_link("Clarence")
    first(:link,"http://clarence.ninja/blog").click
    assert_equal "/sources/clarence/urls/blog", current_path
    assert page.has_content?("37")
    assert page.has_content?("OpenBSD")
    assert page.has_content?("Firefox")
    assert page.has_content?("GET")
    assert page.has_content?("http://www.google.com")
  end

  def test_user_can_see_url_specific_details_for_url_with_deep_path
   visit '/'
   click_link("Clarence")
   first(:link,"http://clarence.ninja/ballin/like/a/boss").click
   assert_equal "/sources/clarence/urls/ballin/like/a/boss", current_path
  end

  def test_user_can_see_an_error_if_there_is_no_url
    visit '/sources/clarence/urls/blogg'
    assert page.has_content?("The URL, http://clarence.ninja/blogg, has had zero requests.")
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
    Request.create(user_id: 1,
                   url_id: 2,
                   browser_id: 1,
                   operating_system_id: 1,
                   resolution_id: 1,
                   referral_id: 1,
                   type_id: 1,
                   event_id: 1,
                   response_time: 37,
                   requested_at: "2013-01-14 21:38:28 -0700",
                   sha: "123abc")
   Url.create(address: "http://clarence.ninja/blog")
   Url.create(address: "http://clarence.ninja/ballin/like/a/boss")
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
