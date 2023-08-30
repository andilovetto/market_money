require "rails_helper"

RSpec.describe "market vendor request" do
  describe "market vendors create action" do
    context "when valid ids for vendor and market are passed in, a market vendor will be created" do
      it "returns status 201" do
        market_1 = create(:market)
        vendor_1 = create(:vendor)

        create_params = {
          "market_id": market_1.id,
          "vendor_id": vendor_1.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        post "/api/v0/market_vendors", headers: headers, params: create_params.to_json

        create_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(201)
        expect(create_response).to have_key(:message)
        expect(create_response[:message]).to eq("Successfully added vendor to market")
      end
    end

    context "when an invalid market id is passed in, it will raise an error" do
      it "returns status 404" do
        market_1 = create(:market)
        vendor_1 = create(:vendor)

        create_params = {
          "market_id": 123123123123,
          "vendor_id": vendor_1.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        post "/api/v0/market_vendors", headers: headers, params: create_params.to_json

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Validation failed: Market must exist")
      end
    end

    context "when an existing market vendor with those values already exists, it will raise an error" do
      it "returns status 422" do
        market_1 = create(:market)
        vendor_1 = create(:vendor)
        market_vendor_1 = MarketVendor.create(market_id: market_1.id, vendor_id: vendor_1.id)

        create_params = {
          "market_id": market_1.id,
          "vendor_id": vendor_1.id
        }

        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        post "/api/v0/market_vendors", headers: headers, params: create_params.to_json

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(422)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("PG::UniqueViolation: ERROR:  duplicate key value violates unique constraint \"index_market_vendors_on_market_id_and_vendor_id\"\nDETAIL:  Key (market_id, vendor_id)=(#{market_1.id}, #{vendor_1.id}) already exists.\n")
      end
    end


  end
end