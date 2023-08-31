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

  def search
    if params[:state] && params[:name] && params[:city] 
      markets = Market.where(state: params[:state], name: params[:name], city: params[:city])
      render json: MarketSerializer.new(markets)
    elsif params[:state] && params[:city]
      markets = Market.where(state: params[:state], city: params[:city])
      render json: MarketSerializer.new(markets)
    elsif params[:state] && params[:name]
      markets = Market.where(state: params[:state], name: params[:name])
      render json: MarketSerializer.new(markets)
    elsif params[:name] && !params[:city]
      markets = Market.where(name: params[:name])
      render json: MarketSerializer.new(markets)
    elsif params[:state] && !params[:city]
      markets = Market.where(state: params[:state])
      render json: MarketSerializer.new(markets)
    else
      render json: {
        "errors": [
          {
            "detail": "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
          }
        ]
      }, status: 422
    end
  end

  def nearest_atms
    begin
      market = Market.find(params[:id])
      atms = AtmFacade.get_atms(market.lat, market.lon)
      render json: AtmSerializer.new(atms)
    rescue StandardError => e
      render json: ErrorSerializer.error_handler(e), status: 404
    end
  end


  private

  def market_params
    params.permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end

  def search_response
    markets = Market.where(market_params)
    render json: MarketSerializer.new(markets)
  end
end