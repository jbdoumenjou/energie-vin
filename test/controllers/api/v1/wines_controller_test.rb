# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class WinesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @wine1 = wines(:one)
        @wine2 = wines(:two)
        @wine3 = wines(:three)

        @rating1 = ratings(:one)
        @expected
      end

      test 'should get index' do
        get api_v1_wines_url
        assert_response :success

        wines = JSON.parse(response.body)
        assert_equal 3, wines.length

        assert_wine_equal(@wine3, wines[0])
        assert_wine_equal(@wine1, wines[1])
        assert_wine_equal(@wine2, wines[2])
      end

      test 'should filter wines by price range and order by average_rating' do
        get api_v1_wines_url, params: { price_min: 5, price_max: 10 }
        assert_response :success

        wines = JSON.parse(response.body)
        assert_equal 2, wines.length

        assert_equal @wine3.id, wines[0]['id']
        assert_equal @wine1.id, wines[1]['id']
      end

      test 'should return empty result for no matching wines' do
        get api_v1_wines_url, params: { price_min: 100, price_max: 200 }
        assert_response :success

        wines = JSON.parse(response.body)
        assert_equal [], wines
      end

      test 'expert should be able to create rating for wine' do
        wine = wines(:one)
        rating_count = wine.ratings.count

        post ratings_api_v1_wine_url(wine), params: { rating: { value: 8, expert_id: 42 } }
        rating = JSON.parse(response.body)

        assert_equal 42, rating['expert_id']
        assert_equal 8.0, BigDecimal(rating['value'])

        # checks that the wine has been updated with the right average rating
        wine.reload

        assert_equal rating_count + 1, wine.ratings.count
        assert_equal 7, wine.average_rating
      end

      test 'rating creation should fail with invalid value' do
        wine = wines(:one)
        rating_count = wine.ratings.count
        post ratings_api_v1_wine_url(wine), params: { rating: { value: -2, expert_id: 1 } }

        assert_response :unprocessable_entity
        assert_equal rating_count, wine.ratings.count
      end

      test 'should get ratings for a wine' do
        # Create some ratings for the wine
        rating1 = @wine3.ratings.create(value: 8, expert_id: 1)
        rating2 = @wine3.ratings.create(value: 6, expert_id: 2)

        get ratings_api_v1_wine_url(@wine3)
        assert_response :success

        ratings = JSON.parse(response.body)
        assert_equal 2, ratings.length

        assert_equal rating1.id, ratings[0]['id']
        assert_equal rating2.id, ratings[1]['id']
      end

      test 'should return empty list if no ratings exist for a wine' do
        get ratings_api_v1_wine_url(@wine3)
        assert_response :success

        ratings = JSON.parse(response.body)
        assert_empty ratings
      end

      test 'should delete a rating for a wine' do
        delete delete_rating_api_v1_wine_url(@wine1, @rating1)
        assert_response :no_content

        assert_nil Rating.find_by(id: @rating1.id)
      end

      test 'should update a rating for a wine' do
        new_rating_value = 9
        put update_rating_api_v1_wine_url(@wine1, @rating1), params: { rating: { value: new_rating_value } }
        assert_response :success

        @rating1.reload
        assert_equal new_rating_value, @rating1.value
      end

      private

      def assert_wine_equal(expected_wine, actual_wine)
        assert_equal expected_wine.name, actual_wine['name']
        assert_equal expected_wine.lowest_price, BigDecimal(actual_wine['lowest_price'])
        assert_equal expected_wine.highest_price, BigDecimal(actual_wine['highest_price'])
        assert_equal expected_wine.average_rating, BigDecimal(actual_wine['average_rating'])
      end
    end
  end
end
