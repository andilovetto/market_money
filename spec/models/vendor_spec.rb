require "rails_helper"

RSpec.describe Vendor do
  describe "relationships" do
    it { should have_many :market_vendors  }
    it { should have_many(:markets).through(:market_vendors)  }
    
  end
end