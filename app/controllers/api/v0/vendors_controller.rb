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
      vendor
      render json: VendorSerializer.new(vendor)
    rescue StandardError => e
      render json: ErrorSerializer.error_handler(e), status: 404
    end
  end

  def create
    begin
      vendor = Vendor.new(vendor_params)
      vendor.save!
      render json: VendorSerializer.new(vendor), status: 201
    rescue StandardError => e
      render json: ErrorSerializer.error_handler(e), status: 400
    end
  end

  def update
    begin
      vendor
      vendor.update!(vendor_params)
      render json: VendorSerializer.new(vendor)
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.error_handler(e), status: 404
    rescue ActiveRecord::RecordInvalid => e
      render json: ErrorSerializer.error_handler(e), status: 400
    end
  end

  def destroy
      begin
      vendor.destroy
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.error_handler(e), status: 404
    end
  end

  private

  def vendor_params
    params.permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def vendor
    vendor ||= Vendor.find(params[:id])
  end
end