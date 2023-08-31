class AtmService


  def self.find_atms(lat, lon)
    # ?lat=#{lat}&lon=#{lon}&radius=10000&categorySet=7397
    response = conn.get do |f|
      f.params["key"] = "16OiFmAd0hk6HbrnuWSAro5E6sgXhzBU"
      f.params["lat"] = lat
      f.params["lon"] = lon
      f.params["radius"] = 10000
      f.params["categorySet"] = 7397
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    url = "https://api.tomtom.com/search/2/nearbySearch/.json"
    Faraday.new(url: url)
  end
end