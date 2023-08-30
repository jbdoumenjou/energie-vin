require "test_helper"

class PriceTest < ActiveSupport::TestCase
  setup do
    @wine = wines(:one) # Assuming you have a fixture named 'wines'
    @price = Price.new(wine: @wine, price: 19.99)
  end

  test "should be valid" do
    assert @price.valid?
  end

  test "should require a wine" do
    @price.wine = nil
    assert_not @price.valid?
  end

  test "should require a price" do
    @price.price = nil
    assert_not @price.valid?
  end

  test "price should be greater than or equal to 0" do
    @price.price = -1
    assert_not @price.valid?
  end

  test "price can be 0" do
    @price.price = 0
    assert @price.valid?
  end

  test "price can be greater than 0" do
    @price.price = 9.99
    assert @price.valid?
  end
end
