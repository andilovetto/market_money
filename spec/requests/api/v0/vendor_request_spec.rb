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

    context "when credit accepted field is not a boolean" do
      it "returns status 400" do
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

  describe "vendor update action" do
    context "any attribute passed for an existing vendor will update that vendor" do
        it "returns status 200" do
          update_params = {
              "contact_name": "Kimberly Couwer",
              "credit_accepted": false
            }
          headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

          vendor_1 = create(:vendor)

          patch "/api/v0/vendors/#{vendor_1.id}", headers: headers, params: update_params.to_json

          update_response = JSON.parse(response.body, symbolize_names: true)

          expect(response.status).to eq(200)
          expect(update_response).to have_key(:data)
          expect(update_response[:data]).to have_key(:id)
          expect(update_response[:data]).to have_key(:type)
          expect(update_response[:data]).to have_key(:attributes)
          expect(update_response[:data][:attributes]).to have_key(:name)
          expect(update_response[:data][:attributes]).to have_key(:description)
          expect(update_response[:data][:attributes]).to have_key(:contact_name)
          expect(update_response[:data][:attributes][:contact_name]).to eq("Kimberly Couwer")
          expect(update_response[:data][:attributes]).to have_key(:contact_phone)
          expect(update_response[:data][:attributes]).to have_key(:credit_accepted)
          expect(update_response[:data][:attributes][:credit_accepted]).to be(false)
        end
      end
    end

    context "attempting to update a nonexistent vendor raises an error" do
      it "returns status 404" do
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        patch "/api/v0/vendors/123123123123", headers: headers

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      end
    end

    context "updating vendor attributes with blank fields raises an error" do
      it "returns status 400" do
        update_params = {
          "contact_name": "",
          "credit_accepted": false
          }
        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        vendor_1 = create(:vendor)

        patch "/api/v0/vendors/#{vendor_1.id}", headers: headers, params: update_params.to_json

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank")
      end
    end
  end

  describe "vendor destroy action" do
    context "when a valid id is passed in, that vendor will be destroyed, as well as its associations" do
      it "returns status 204" do
        vendor_1 = create(:vendor)

        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        delete "/api/v0/vendors/#{vendor_1.id}", headers: headers

        expect(response.status).to eq(204)
        expect { Vendor.find(vendor_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when an invalid id is passed it will raise an error" do
      it "returns status 404" do

        headers = { 'CONTENT_TYPE' => 'application/json', "Accept" => 'application/json' }

        delete "/api/v0/vendors/123123123123", headers: headers

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(error_response).to have_key(:errors)
        expect(error_response[:errors][0]).to have_key(:detail)
        expect(error_response[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      end
    end
  end
end