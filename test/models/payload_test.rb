require_relative '../test_helper'

class EventTest < Minitest::Test
  def test_it_assigns_proper_attributes
    attributes = {name: "tubbin"}
    event = Event.new(attributes)
    assert_equal "tubbin", event.name
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end