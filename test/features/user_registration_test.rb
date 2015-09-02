require_relative '../test_helper'

class UserRegistrationTest < FeatureTest

  def test_user_can_register
    visit "/"
    click_link "Register Here"

    fill_in "identifier", with: "jumpstarcrab"
    fill_in "rootUrl", with: "http://jumpstarcrab.com"
    click_button "sources_submit"

    assert_equal "/sources", current_path
    assert page.has_content?("{\"identifier\":\"jumpstarcrab\"}")
  end

  def test_registration_yields_400_when_missing_identifier
    visit "/"
    click_link "Register Here"

    fill_in "rootUrl", with: "http://jumpstarcrab.com"
    click_button "sources_submit"

    assert_equal "/sources", current_path
    assert page.has_content?("Identifier can't be blank")
  end

  def test_registration_yields_400_when_missing_root_url
    visit "/"
    click_link "Register Here"

    fill_in "identifier", with: "jumpstarcrab"
    click_button "sources_submit"

    assert_equal "/sources", current_path
    assert page.has_content?("Root url can't be blank")
  end

  def test_registration_yields_403_given_duplicate_identifier
    visit "/"
    click_link "Register Here"

    fill_in "identifier", with: "jumpstarcrab"
    fill_in "rootUrl", with: "http://jumpstarcrab.com"
    click_button "sources_submit"

    visit "/sources"

    fill_in "identifier", with: "jumpstarcrab"
    fill_in "rootUrl", with: "http://jumpstarcrab.com"
    click_button "sources_submit"

    assert_equal "/sources", current_path
    assert page.has_content?("Identifier has already been taken")
  end


  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

end
