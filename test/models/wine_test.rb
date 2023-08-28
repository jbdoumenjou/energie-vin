require "test_helper"

class WineTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    wine = Wine.new(
      lowest_price: 10.00,
      highest_price: 50.00,
      average_rating: 7.5
    )
    assert wine.valid?
  end

  test "should not be valid without lowest_price" do
    wine = Wine.new(lowest_price: nil)
    assert_not wine.valid?
  end

  test "should not be valid without highest_price" do
    wine = Wine.new(highest_price: nil)
    assert_not wine.valid?
  end

  test "should not be valid without rating" do
    wine = Wine.new(average_rating: nil)
    assert_not wine.valid?
  end

  test "should not be valid if rating is less than 0" do
    wine = Wine.new(average_rating: -1)
    assert_not wine.valid?
  end

  test "should not be valid if rating is greater than 10" do
    wine = Wine.new(average_rating: 11)
    assert_not wine.valid?
  end
end
