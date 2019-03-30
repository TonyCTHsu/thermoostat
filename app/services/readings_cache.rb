class ReadingsCache
  def self.store(reading)
    Rails.cache.write(
      "thermostats/#{reading.thermostat_id}/readings/#{reading.number}",
      reading.attributes,
      expires_in: 1.hour
    )
  end

  def self.read(thermostat, reading_number)
    Rails.cache.read("thermostats/#{thermostat.id}/readings/#{reading_number}")
  end
end
