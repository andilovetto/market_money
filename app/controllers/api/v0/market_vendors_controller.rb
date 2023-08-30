class Api::V0::MarketVendorsController < ApplicationController

  def create
    begin
      MarketVendor.create!(market_vendor_params)
      render json: { "message": "Successfully added vendor to market" }, status: 201
    rescue ActiveRecord::RecordInvalid => e
      render json: ErrorSerializer.error_handler(e), status: 404
    rescue ActiveRecord::RecordNotUnique => e
      render json: ErrorSerializer.error_handler(e), status: 422
    end
  end


  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end