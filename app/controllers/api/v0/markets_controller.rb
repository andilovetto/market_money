class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    render json: MarketSerializer.new(markets)
  end
  
  def show
    begin 
      market = Market.find(params[:id])
      render json: MarketSerializer.new(market)
    rescue StandardError => e
      render json: ErrorSerializer.error_handler(e), status: 404
    end
  end
end