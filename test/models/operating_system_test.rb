require_relative '../test_helper'

class OperatingSystemTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = "{Mozilla/3.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17}"
    os = UserAgent.parse(attributes).platform
    os = OperatingSystem.find_or_create_by({:name => os})
    assert_equal "Macintosh%3B Intel Mac OS X 10_8_2", os.name
  end
end