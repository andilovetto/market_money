require "rails_helper"

RSpec.describe "vendor request" do
  describe "vendors index action" do
    it "returns all vendors" do
      create_list(:vendor, 10)
      market = create(:market)
      headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
      get "/api/v0/markets/#{market.id}/vendors", headers: headers

      index_response = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(200)
      expect(index_response).to have_key(:data)
      index_response[:data].each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor).to have_key(:type)
        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_a String
        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a String
        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a String
        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a String
        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
      end
    end

    context "when call is unsuccessful" do
      it "returns status 404" do
        market_1 = create(:market)
        vendor_1 = create(:vendor)
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
        get "/api/v0/markets/123123123123/vendors", headers: headers
  
        error_response = JSON.parse(response.body, symbolize_names: true)
  
        expect(response.status).to eq(404)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
      end
    end
  end

  describe "vendor show action" do
    context "when call is successful" do
      it "returns a vendor" do
        market_1 = create(:market)
        vendor_1 = create(:vendor)
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
        get "/api/v0/vendors/#{vendor_1.id}", headers: headers

        show_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(show_response).to have_key(:data)
        expect(show_response[:data]).to have_key(:id)
        expect(show_response[:data]).to have_key(:type)
        expect(show_response[:data]).to have_key(:attributes)
        expect(show_response[:data][:attributes]).to have_key(:name)
        expect(show_response[:data][:attributes][:name]).to be_a String
        expect(show_response[:data][:attributes]).to have_key(:description)
        expect(show_response[:data][:attributes][:description]).to be_a String
        expect(show_response[:data][:attributes]).to have_key(:contact_name)
        expect(show_response[:data][:attributes][:contact_name]).to be_a String
        expect(show_response[:data][:attributes]).to have_key(:contact_phone)
        expect(show_response[:data][:attributes][:contact_phone]).to be_a String
        expect(show_response[:data][:attributes]).to have_key(:credit_accepted)
        expect(show_response[:data][:attributes][:credit_accepted]).to be_in([true, false])
      end
    end

    context "when call is unsuccessful" do
      it "returns status 404" do
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }
        get "/api/v0/vendors/123123123123", headers: headers

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      end
    end
  end
end