# frozen_string_literal: true

require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  setup do
    @wine = wines(:one)
    @price = Price.new(wine: @wine, price: 19.99, seller_site: 'www.example.wine.com')
  end

  test 'should be valid' do
    assert @price.valid?
  end

  test 'should require a wine' do
    @price.wine = nil
    assert_not @price.valid?
  end

  test 'should require a price' do
    @price.price = nil
    assert_not @price.valid?
  end

  test 'price should be greater than or equal to 0' do
    @price.price = -1
    assert_not @price.valid?
  end

  test 'price can be 0' do
    @price.price = 0
    assert @price.valid?
  end

  test 'price can be greater than 0' do
    @price.price = 9.99
    assert @price.valid?
  end

  test 'seller_site cannot be empty' do
    @price.seller_site = ''
    assert_not @price.valid?
  end
end
