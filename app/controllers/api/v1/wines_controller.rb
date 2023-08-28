# frozen_string_literal: true

module Api
  module V1
    # Controller for managing wines through the API.
    class WinesController < ApplicationController
      # Retrieves a list of wines based on optional price filters and orders them by rating.
      #
      # GET /api/v1/wines
      #
      # Params:
      # - price_min (optional): Minimum wine price.
      # - price_max (optional): Maximum wine price.
      #
      # Response:
      # - JSON array of wines.
      #
      # Example Request:
      #   GET /api/v1/wines?price_min=20&price_max=50
      #
      # Example Response:
      #   HTTP/1.1 200 OK
      #   [
      #     { "id": 1, "name": "Red Wine", ... },
      #     { "id": 2, "name": "White Wine", ... },
      #     ...
      #   ]
      #
      # @return [void]
      def index
        wines = Wine.all
                    .price_max(params[:price_max])
                    .price_min(params[:price_min])
                    .order_by_rating

        render json: wines, status: :ok
      end
    end
  end
end
