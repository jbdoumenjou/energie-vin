# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class PricesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @wine = wines(:one)
        @price = prices(:one)
      end

      # test 'should get index' do
      #   get api_v1_wine_prices_url(@wine)
      #   assert_response :success

      #   json_response = JSON.parse(response.body)
      #   assert_equal 1, json_response.length
      #   assert_equal @price.id, json_response[0]['id']
      # end

      # test 'should show price' do
      #   get api_v1_wine_price_url(@wine, @price)
      #   assert_response :success

      #   json_response = JSON.parse(response.body)
      #   assert_equal @price.id, json_response['id']
      # end

      test 'should create price' do
        @wine3 = wines(:three)
        assert_difference('Price.count') do
          post api_v1_wine_prices_url(@wine3), params: { price: { price: 15.99, seller_site: 'www.example.wine.com' } }
        end

        assert_response :created
      end

      test 'should create price and update the wine lowest price' do
        @wine3 = wines(:three)

        assert_difference('Price.count') do
          post api_v1_wine_prices_url(@wine3), params: { price: { price: 4.99, seller_site: 'www.example.wine.com' } }
        end

        @wine3.reload
        assert_equal 4.99, BigDecimal(@wine3.lowest_price)

        assert_response :created
      end

      test 'should create price and update the wine highest price' do
        @wine3 = wines(:three)

        assert_difference('Price.count') do
          post api_v1_wine_prices_url(@wine3), params: { price: { price: 40.99, seller_site: 'www.example.wine.com' } }
        end

        @wine3.reload
        assert_equal 40.99, BigDecimal(@wine3.highest_price)

        assert_response :created
      end

      test 'should update price' do
        patch api_v1_wine_price_url(@wine, @price), params: { price: { price: 10.0 } }
        assert_response :success

        @price.reload
        assert_equal 10.0, BigDecimal(@price.price)
      end

      test 'should update price and update the wine lowest price' do
        patch api_v1_wine_price_url(@wine, @price), params: { price: { price: 3.0 } }
        assert_response :success

        @price.reload
        assert_equal 3.0, BigDecimal(@price.price)

        @wine.reload
        assert_equal 3.0, @wine.lowest_price
      end

      test 'should update price and update the wine highest price' do
        patch api_v1_wine_price_url(@wine, @price), params: { price: { price: 3.0 } }
        assert_response :success

        @price.reload
        assert_equal 3.0, BigDecimal(@price.price)

        @wine.reload
        assert_equal 3.0, @wine.lowest_price
      end

      test 'should destroy price' do
        assert_difference('Price.count', -1) do
          delete api_v1_wine_price_url(@wine, @price)
        end

        assert_response :no_content
      end
    end
  end
end
