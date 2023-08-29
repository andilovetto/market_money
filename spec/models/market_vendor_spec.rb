require "rails_helper"

RSpec.describe MarketVendor do
  describe "relationships" do
    it { should belong_to :market  }
    it { should belong_to :vendor  }
  end
end