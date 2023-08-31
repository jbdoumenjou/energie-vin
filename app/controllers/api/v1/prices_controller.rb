# frozen_string_literal: true

module Api
  module V1
    # Controller for managing wines prices through the API.
    class PricesController < ApplicationController
      before_action :find_wine

      # Retrieves a list of prices for a specific wine.
      #
      # GET /api/v1/wines/:wine_id/prices
      #
      # Params:
      # - wine_id: The ID of the wine for which to retrieve prices.
      #
      # Response:
      # - JSON array of prices.
      #
      # Example Request:
      #   GET /api/v1/wines/1/prices
      #
      # Example Response:
      #   HTTP/1.1 200 OK
      #   [
      #     { "id": 1, "price": 10.0, ... },
      #     { "id": 2, "price": 15.0, ... },
      #     ...
      #   ]
      #
      # @return [void]
      def index
        @prices = @wine.prices
        render json: @prices, status: :ok
      end

      # Creates a new price for a specific wine.
      #
      # POST /api/v1/wines/:wine_id/prices
      #
      # Params:
      # - wine_id: The ID of the wine for which to create a price.
      # - price: The price value to be added.
      #
      # Response:
      # - JSON representation of the created price.
      #
      # Example Request:
      #   POST /api/v1/wines/1/prices
      #   {
      #     "price": 20.0
      #   }
      #
      # Example Response:
      #   HTTP/1.1 201 Created
      #   {
      #     "id": 3, "price": 20.0, ...
      #   }
      #
      # @return [void]
      def create
        @price = @wine.prices.build(price_params)
        if @price.save
          @wine.update_price(@price.seller_site, @price.price)
          render json: @price, status: :created
        else
          render json: @price.errors, status: :unprocessable_entity
        end
      end

      def show
        @price = @wine.prices.find(params[:id])
        render json: @price, status: :ok
      end

      # Updates an existing price for a specific wine.
      #
      # PATCH /api/v1/wines/:wine_id/prices/:id
      #
      # Params:
      # - wine_id: The ID of the wine for which to update a price.
      # - id: The ID of the price to be updated.
      # - price: The updated price value.
      #
      # Response:
      # - JSON representation of the updated price.
      #
      # Example Request:
      #   PATCH /api/v1/wines/1/prices/3
      #   {
      #     "price": 25.0
      #   }
      #
      # Example Response:
      #   HTTP/1.1 200 OK
      #   {
      #     "id": 3, "price": 25.0, ...
      #   }
      #
      # @return [void]
      def update
        @price = @wine.prices.find(params[:id])

        if @price.update(price_params)
          @wine.update_price(@price.seller_site, @price.price)
          render json: @price, status: :ok
        else
          render json: @price.errors, status: :unprocessable_entity
        end
      end

      # Destroys an existing price for a specific wine.
      #
      # DELETE /api/v1/wines/:wine_id/prices/:id
      #
      # Params:
      # - wine_id: The ID of the wine for which to delete a price.
      # - id: The ID of the price to be deleted.
      #
      # Response:
      # - No content.
      #
      # @return [void]
      def destroy
        @price = @wine.prices.find(params[:id])
        if @price.destroy
          head :no_content
        else
          render json: @price.errors, status: :unprocessable_entity
        end
      end

      private

      # Finds the wine associated with the request.
      def find_wine
        @wine = Wine.find(params[:wine_id])
      end

      # Strong parameters for price creation and update.
      def price_params
        params.require(:price).permit(:price, :seller_site)
      end
    end
  end
end
