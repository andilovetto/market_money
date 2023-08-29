class Api::V0::VendorsController < ApplicationController
  def index
    begin 
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
    rescue StandardError => e
      render json: ErrorSerializer.error_handler(e), status: 404
    end
  end
end