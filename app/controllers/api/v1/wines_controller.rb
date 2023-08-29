# frozen_string_literal: true

module Api
  module V1
    # Controller for managing wines through the API.
    class WinesController < ApplicationController
      before_action :find_wine, only: %i[create_rating ratings destroy_rating update_rating]

      # Retrieves a list of wines based on optional price filters and orders them by rating.
      #
      # GET /api/v1/wines
      #
      # @param [Hash] query_params Optional query parameters.
      # @option query_params [Float] :price_min Minimum wine price (optional).
      # @option query_params [Float] :price_max Maximum wine price (optional).
      # @return [JSON] A JSON array of wines.
      # @status 200 OK - When the request is successful.
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
      def index
        wines = Wine.all
                    .price_max(params[:price_max])
                    .price_min(params[:price_min])
                    .order_by_rating

        render json: wines, status: :ok
      end

      # Creates a new rating for a specific wine.
      #
      # POST /api/v1/wines/:id/ratings
      #
      # Example Response:
      #
      # HTTP/1.1 201 Created
      #
      # {
      #   "id": 789,
      #   "value": 8,
      #   "expert_id": 456,
      #   "wine_id": 123,
      #   "created_at": "2023-08-30T12:34:56Z",
      #   "updated_at": "2023-08-30T12:34:56Z"
      # }
      #
      # @param [Integer] id The ID of the wine for which to create a rating.
      # @param [Hash] rating_params The parameters for the rating.
      # @option rating_params [Float] :value The rating value between 0 and 10.
      # @option rating_params [Integer] :user_id The ID of the expert user who is submitting the rating.
      # @return [JSON] A JSON representation of the created rating or error messages.
      # @status 201 Created - When the rating is successfully created.
      # @status 422 Unprocessable Entity - When the rating creation fails due to invalid data.
      #
      def create_rating
        @rating = @wine.ratings.find_or_initialize_by(expert_id: params[:rating][:expert_id])
        @rating.value = params[:rating][:value]

        if @rating.save
          @wine.update_average_rating
          render json: @rating, status: :created
        else
          render json: @rating.errors, status: :unprocessable_entity
        end
      end

      # Retrieves a list of ratings for a specific wine.
      #
      # GET /api/v1/wines/:id/ratings
      #
      # Params:
      # - id (required): The ID of the wine.
      #
      # Response:
      # - JSON array of ratings.
      #
      # Example Request:
      #   GET /api/v1/wines/1/ratings
      #
      # Example Response:
      #   HTTP/1.1 200 OK
      #   [
      #     { "id": 1, "value": 5, "expert_id": 1, "created_at": "2023-08-30T10:00:00Z", ... },
      #     { "id": 2, "value": 7, "expert_id": 2, "created_at": "2023-08-30T11:00:00Z", ... },
      #     ...
      #   ]
      #
      # @return [void]
      def ratings
        @ratings = @wine.ratings

        render json: @ratings, status: :ok
      end

      # Updates a specific rating for a wine.
      #
      # PUT /api/v1/wines/:id/ratings/:rating_id
      #
      # Params:
      # - id (required): The ID of the wine.
      # - rating_id (required): The ID of the rating to be updated.
      # - rating (required): The updated rating attributes.
      #   - value (required): The new value of the rating.
      #
      # Response:
      # - JSON representation of the updated rating.
      #
      # Example Request:
      #   PUT /api/v1/wines/1/ratings/3
      #   {
      #     "rating": {
      #       "value": 8
      #     }
      #   }
      #
      # Example Response:
      #   HTTP/1.1 200 OK
      #   {
      #     "id": 3,
      #     "value": 8,
      #     "expert_id": 1,
      #     "created_at": "2023-08-30T09:00:00Z",
      #     "updated_at": "2023-08-30T10:00:00Z",
      #     ...
      #   }
      #
      # @return [void]
      def update_rating
        @rating = @wine.ratings.find(params[:rating_id])

        if @rating.update(value: params[:rating][:value])
          @wine.update_average_rating
          render json: @rating, status: :ok
        else
          render json: @rating.errors, status: :unprocessable_entity
        end
      end

      # Deletes a specific rating for a wine.
      #
      # DELETE /api/v1/wines/:id/ratings/:rating_id
      #
      # Params:
      # - id (required): The ID of the wine.
      # - rating_id (required): The ID of the rating to be deleted.
      #
      # Response:
      # - No content.
      #
      # Example Request:
      #   DELETE /api/v1/wines/1/ratings/3
      #
      # Example Response:
      #   HTTP/1.1 204 No Content
      #
      # @return [void]
      def destroy_rating
        @rating = @wine.ratings.find(params[:rating_id])

        if @rating.destroy
          @wine.update_average_rating
          head :no_content
        else
          render json: @rating.errors, status: :unprocessable_entity
        end
      end

      private

      def find_wine
        @wine = Wine.find(params[:id])
      end
    end
  end
end
