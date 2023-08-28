# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class WinesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @wine1 = wines(:one)
        @wine2 = wines(:two)
        @wine3 = wines(:three)

        @expected
      end

      test 'should get index' do
        get api_v1_wines_url
        assert_response :success

        wines = JSON.parse(response.body)
        assert_equal 3, wines.length

        p wines

        assert_wine_equal(@wine3, wines[0])
        # assert_wine_equal(@wine1, wines[1])
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
