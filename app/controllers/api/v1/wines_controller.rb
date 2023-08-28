class Api::V1::WinesController < ApplicationController
    def index
        wines = Wine.all
        .price_max(params[:price_max])
        .price_min(params[:price_min])
        .order_by_rating

      
        render json: wines, status: :ok
    end
end
