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

  describe "vendor create action" do
    context "when all required attributes are passed" do
      it "returns status 201 with newly created vendor resource" do
        create_params = {
          "name": "Buzzy Bees",
          "description": "local honey and wax products",
          "contact_name": "Berly Couwer",
          "contact_phone": "8389928383",
          "credit_accepted": false
        }
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        post "/api/v0/vendors", headers: headers, params: create_params.to_json

        create_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(201)
        expect(create_response).to have_key(:data)
        expect(create_response[:data]).to have_key(:id)
        expect(create_response[:data]).to have_key(:type)
        expect(create_response[:data]).to have_key(:attributes)
        expect(create_response[:data][:attributes]).to have_key(:name)
        expect(create_response[:data][:attributes][:name]).to eq("Buzzy Bees")
        expect(create_response[:data][:attributes]).to have_key(:description)
        expect(create_response[:data][:attributes][:description]).to eq("local honey and wax products")
        expect(create_response[:data][:attributes]).to have_key(:contact_name)
        expect(create_response[:data][:attributes][:contact_name]).to eq("Berly Couwer")
        expect(create_response[:data][:attributes]).to have_key(:contact_phone)
        expect(create_response[:data][:attributes][:contact_phone]).to eq("8389928383")
        expect(create_response[:data][:attributes]).to have_key(:credit_accepted)
        expect(create_response[:data][:attributes][:credit_accepted]).to be(false)
      end
    end

    context "when all required attributes are not passed" do
      it "returns status 400" do
        create_params = {
          "name": "Buzzy Bees",
          "description": "local honey and wax products",
          "credit_accepted": false
        }
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        post "/api/v0/vendors", headers: headers, params: create_params.to_json

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
      end

      it "returns status 400 when credit accepted is not a boolean" do
        create_params = {
          "name": "Buzzy Bees",
          "description": "local honey and wax products",
          "contact_name": "Berly Couwer",
          "contact_phone": "8389928383",
          "credit_accepted": nil
        }
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        post "/api/v0/vendors", headers: headers, params: create_params.to_json

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Validation failed: Credit accepted is not included in the list, Credit accepted is reserved")
      end
    end
  end
end