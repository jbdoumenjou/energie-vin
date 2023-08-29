# frozen_string_literal: true

require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  def setup
    @wine = wines(:one)
    @rating = Rating.new(wine: @wine, expert_id: 1, value: 7)
  end

  test 'should be valid' do
    assert @rating.valid?
  end

  test 'should be invalid without expert_id' do
    @rating.expert_id = nil
    assert_not @rating.valid?
    assert_includes @rating.errors[:expert_id], "can't be blank"
  end

  test 'should be invalid without value' do
    @rating.value = nil
    assert_not @rating.valid?
    assert_includes @rating.errors[:value], "can't be blank"
  end

  test 'should be invalid with value less than 0' do
    @rating.value = -1
    assert_not @rating.valid?
    assert_includes @rating.errors[:value], 'must be greater than or equal to 0'
  end

  test 'should be invalid with value greater than 10' do
    @rating.value = 11
    assert_not @rating.valid?
    assert_includes @rating.errors[:value], 'must be less than or equal to 10'
  end
end
