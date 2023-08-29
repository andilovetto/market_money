require "rails_helper"

RSpec.describe Market do
  describe "relationships" do
    it { should have_many :market_vendors  }
    it { should have_many(:vendors).through(:market_vendors)  }
  end

  describe "instance methods" do
    describe "#vendor_count" do
      it "returns vendor count for a market" do
        market_1 = create(:market) 
        vendor_1 = create(:vendor) 
        vendor_2 = create(:vendor)
        market_vendor_1 = MarketVendor.create!(vendor_id: vendor_1.id, market_id: market_1.id)
        market_vendor_2 = MarketVendor.create!(vendor_id: vendor_2.id, market_id: market_1.id)
        
        market_2 = create(:market) 
        vendor_3 = create(:vendor) 
        market_vendor_3 = MarketVendor.create!(vendor_id: vendor_1.id, market_id: market_2.id)
        market_vendor_4 = MarketVendor.create!(vendor_id: vendor_2.id, market_id: market_2.id)
        market_vendor_5 = MarketVendor.create!(vendor_id: vendor_3.id, market_id: market_2.id)
        
        expect(market_1.vendor_count).to eq(2)
        expect(market_2.vendor_count).to eq(3)
      end
    end
  end
end