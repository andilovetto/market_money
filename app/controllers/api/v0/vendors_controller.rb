class Api::V0::VendorsController < ApplicationController
  def index
    begin 
      market = Market.find(params[:market_id])
      render json: VendorSerializer.new(market.vendors)
    rescue StandardError => e
      render json: ErrorSerializer.error_handler(e), status: 404
    end
  end

  def show
    begin
      vendor = Vendor.find(params[:id])
      render json: VendorSerializer.new(vendor)
    rescue StandardError => e
      render json: ErrorSerializer.error_handler(e), status: 404
    end
  end

  def create
    vendor = Vendor.new(vendor_params)
    begin
      vendor.save!
      
      render json: VendorSerializer.new(vendor), status: 201
    rescue StandardError => e
      
      render json: ErrorSerializer.error_handler(e), status: 400
    end
  end

  private

  def vendor_params
    params.permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end