require "rails_helper"

RSpec.describe "markets request" do
  describe "markets index" do
    it "returns all markets" do
      create_list(:market, 10)
      headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
      get "/api/v0/markets", headers: headers
      
      #testing data structure, working my way down the hash response
      markets = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(200)
      # require 'pry'; binding.pry
      expect(markets).to have_key(:data)
      markets[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market).to have_key(:type)
        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a String
        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_an Integer
      end
    end
  end
end