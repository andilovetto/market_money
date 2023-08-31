class AtmFacade
  def self.get_atms(lat, lon)
    atms = AtmService.find_atms(lat, lon)
    atms[:results].map do |atm|
      Atm.new(atm)
    end
  end
end