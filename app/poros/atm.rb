class Atm 

  attr_reader :name,
              :address,
              :lat,
              :lon,
              :distance,
              :id

  def initialize(data)
    @id = nil
    @name = data[:poi][:name]
    @address = create_address(data)
    @lat = data[:position][:lat]
    @lon = data[:position][:lon]
    @distance = data[:dist]
  end


  def create_address(data)
    if data[:address][:streetNumber] # this is fucking bullshit to give an API that doesnt return solid results step your pussy up, paid too much money for dumb shit
      data[:address][:streetNumber] + " " + data[:address][:streetName] + ", " + data[:address][:municipality] + ", " + data[:address][:countrySubdivision] + " " + data[:address][:postalCode]
    else 
      nil
    end
  end
end

