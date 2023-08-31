require "rails_helper"

RSpec.describe "markets request" do
  describe "markets index action" do
    it "returns all markets" do
      create_list(:market, 10)
      headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
      get "/api/v0/markets", headers: headers
      
      #testing data structure, working my way down the hash response
      index_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(200)
      expect(index_response).to have_key(:data)
      index_response[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market).to have_key(:type)
        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a String
        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a String
        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a String
        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a String
        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_a String
        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_a String
        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_a String
        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_a String
        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_an Integer
      end
    end
  end

  describe "market show action" do
    context "when call is successful" do
      it "returns a market" do
        market_1 = create(:market)
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
        get "/api/v0/markets/#{market_1.id}", headers: headers

        show_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(show_response).to have_key(:data)
        expect(show_response[:data]).to have_key(:id)
        expect(show_response[:data]).to have_key(:type)
        expect(show_response[:data]).to have_key(:attributes)
        expect(show_response[:data][:attributes]).to have_key(:name)
        expect(show_response[:data][:attributes][:name]).to be_a String
        expect(show_response[:data][:attributes]).to have_key(:street)
        expect(show_response[:data][:attributes]).to have_key(:city)
        expect(show_response[:data][:attributes]).to have_key(:county)
        expect(show_response[:data][:attributes]).to have_key(:state)
        expect(show_response[:data][:attributes]).to have_key(:zip)
        expect(show_response[:data][:attributes]).to have_key(:lat)
        expect(show_response[:data][:attributes]).to have_key(:lon)
        expect(show_response[:data][:attributes]).to have_key(:vendor_count)
        expect(show_response[:data][:attributes][:vendor_count]).to be_an Integer
      end
    end

    context "when a call is unsuccessful" do
      it "returns status 404" do
        market_1 = create(:market)
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
        get "/api/v0/markets/123123123123", headers: headers

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
      end
    end
  end

  describe 'markets search' do 
    context "when valid parameters are passed in, call is successful" do
      it "returns status 200 with state parameter" do
        create_list(:market, 10, state: "Colorado")
        
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
          
        get "/api/v0/markets/search?state=Colorado", headers: headers
        
        index_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(index_response).to have_key(:data)
        index_response[:data].each do |market|
          expect(market).to have_key(:id)
          expect(market).to have_key(:type)
          expect(market).to have_key(:attributes)
          expect(market[:attributes]).to have_key(:name)
          expect(market[:attributes][:name]).to be_a String
          expect(market[:attributes]).to have_key(:street)
          expect(market[:attributes][:street]).to be_a String
          expect(market[:attributes]).to have_key(:city)
          expect(market[:attributes][:city]).to be_a String
          expect(market[:attributes]).to have_key(:county)
          expect(market[:attributes][:county]).to be_a String
          expect(market[:attributes]).to have_key(:state)
          expect(market[:attributes][:state]).to eq("Colorado")
          expect(market[:attributes]).to have_key(:zip)
          expect(market[:attributes][:zip]).to be_a String
          expect(market[:attributes]).to have_key(:lat)
          expect(market[:attributes][:lat]).to be_a String
          expect(market[:attributes]).to have_key(:lon)
          expect(market[:attributes][:lon]).to be_a String
        end
      end
    end
  end

  describe "market's nearest atm" do
    context "when market id is valid" do
      it "returns nearest atm", :vcr do
        market_1 = create(:market, lat: "35.07904", lon: "-106.60068")

        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        get "/api/v0/markets/#{market_1.id}/nearest_atms", headers: headers

        atm_response = JSON.parse(response.body, symbolize_names: true)

        expect(atm_response).to have_key(:data)
        expect(response.status).to eq(200)
        expect(atm_response[:data][0]).to have_key(:id)
        expect(atm_response[:data][0]).to have_key(:attributes)
        expect(atm_response[:data][0]).to have_key(:type)
        expect(atm_response[:data][0][:type]).to eq("atm")
        expect(atm_response[:data][0][:attributes]).to have_key(:name)
        expect(atm_response[:data][0][:attributes]).to have_key(:address)
        expect(atm_response[:data][0][:attributes][:address]).to eq("3902 Central Avenue Southeast, Albuquerque, NM 87108")
        expect(atm_response[:data][0][:attributes]).to have_key(:lat)
        expect(atm_response[:data][0][:attributes]).to have_key(:lon)
        expect(atm_response[:data][0][:attributes]).to have_key(:distance)
      end
    end

    context "when a call is unsuccessful" do
      it "returns status 404" do
        create(:market)
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
        get "/api/v0/markets/123123123123/nearest_atms", headers: headers

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
      end
    end
  end
end