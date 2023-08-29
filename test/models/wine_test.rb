# frozen_string_literal: true

require 'test_helper'

class WineTest < ActiveSupport::TestCase
  def setup
    @wine = wines(:one)
  end

  test 'should be valid with valid attributes' do
    wine = Wine.new(
      lowest_price: 10.00,
      highest_price: 50.00,
      average_rating: 7.5
    )
    assert wine.valid?
  end

  test 'should not be valid without lowest_price' do
    wine = Wine.new(lowest_price: nil)
    assert_not wine.valid?
  end

  test 'should not be valid without highest_price' do
    wine = Wine.new(highest_price: nil)
    assert_not wine.valid?
  end

  test 'should not be valid without rating' do
    wine = Wine.new(average_rating: nil)
    assert_not wine.valid?
  end

  test 'should not be valid if rating is less than 0' do
    wine = Wine.new(average_rating: -1)
    assert_not wine.valid?
  end

  test 'should not be valid if rating is greater than 10' do
    wine = Wine.new(average_rating: 11)
    assert_not wine.valid?
  end

  test 'should update average_rating when ratings exist' do
    wine = Wine.new(
      lowest_price: 10.00,
      highest_price: 50.00,
      average_rating: 0
    )
    wine.save

    rating1 = Rating.new(
      wine: wine,
      value: 7,
      expert_id: 1
    )
    rating1.save

    rating2 = Rating.new(
      wine: wine,
      value: 8,
      expert_id: 2
    )
    rating2.save

    # Call update_average_rating method
    wine.update_average_rating
    assert_equal 7.5, wine.average_rating
  end

  test 'should set average_rating to 0 when no ratings exist' do
    wine = Wine.new(
      lowest_price: 10.00,
      highest_price: 50.00,
      average_rating: 0
    )
    wine.save

    # Call update_average_rating method
    wine.update_average_rating

    assert_equal 0, wine.average_rating
  end
end
