# frozen_string_literal: true

require 'test_helper'

# Represents the wine price history.
class PriceHistoryTest < ActiveSupport::TestCase
  setup do
    @wine = wines(:one)
    @price_history = PriceHistory.new(wine: @wine, price: 19.99, seller_site: 'www.example.wine.com')
  end

  test 'should be valid' do
    assert @price_history.valid?
  end

  test 'should require a wine' do
    @price_history.wine = nil
    assert_not @price_history.valid?
  end

  test 'should require a price' do
    @price_history.price = nil
    assert_not @price_history.valid?
  end

  test 'price should be greater than or equal to 0' do
    @price_history.price = -1
    assert_not @price_history.valid?
  end

  test 'price can be 0' do
    @price_history.price = 0
    assert @price_history.valid?
  end

  test 'price can be greater than 0' do
    @price_history.price = 9.99
    assert @price_history.valid?
  end

  test 'seller_site cannot be empty' do
    @price_history.seller_site = ''
    assert_not @price_history.valid?
  end
end
