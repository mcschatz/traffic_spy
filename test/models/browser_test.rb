require_relative '../test_helper'

class BrowserTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = "{Mozilla/3.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17}"
    browser = UserAgent.parse(attributes).browser
    browser = Browser.find_or_create_by({:name => browser})
    assert_equal "Chrome", browser.name
  end
end