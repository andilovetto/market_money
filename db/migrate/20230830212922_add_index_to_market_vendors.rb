class AddIndexToMarketVendors < ActiveRecord::Migration[7.0]
  def change
    add_index :market_vendors, [:market_id, :vendor_id], unique: true
  end
end
