class MarketSerializer
  include JSONAPI::Serializer

  set_id :id 
  set_type :market
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count

end