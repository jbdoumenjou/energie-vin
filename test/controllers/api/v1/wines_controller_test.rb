require "test_helper"

class Api::V1::WinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wine1 = wines(:one)
    @wine2 = wines(:two)
    @wine3 = wines(:three)
  end

  test "should get index" do
    get api_v1_wines_url
    assert_response :success

    wines = JSON.parse(response.body)
    expected_response = [
      {
        'id' => @wine3.id,
        'name' => @wine3.name,
        'lowest_price' => @wine3.lowest_price,
        'highest_price' => @wine3.highest_price,
        'average_rating' => @wine3.average_rating
      }, 
      {
        'id' => @wine1.id,
        'name' => @wine1.name,
        'lowest_price' => @wine1.lowest_price,
        'highest_price' => @wine1.highest_price,
        'average_rating' => @wine1.average_rating
      },
      {
        'id' => @wine2.id,
        'name' => @wine2.name,
        'lowest_price' => @wine2.lowest_price,
        'highest_price' => @wine2.highest_price,
        'average_rating' => @wine2.average_rating
      }    
    ]
  end

  test "should filter wines by price range and order by average_rating" do
    get api_v1_wines_url, params: { price_min: 5, price_max: 10 }
    wines = JSON.parse(response.body)
    assert_response :success
    assert_equal 2, wines.length
    assert_equal @wine3.id, wines[0]['id'] 
    assert_equal @wine1.id, wines[1]['id']
  end

  test "should return empty result for no matching wines" do
    get api_v1_wines_url, params: { price_min: 100, price_max: 200 }
    assert_response :success
    
    wines = JSON.parse(response.body)
    assert_equal [], wines
  end
end
