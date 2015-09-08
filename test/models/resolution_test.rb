require_relative '../test_helper'

class ResolutionTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = {description: "1280x720"}
    resolution = Resolution.new(attributes)
    assert_equal "1280x720", resolution.description
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end