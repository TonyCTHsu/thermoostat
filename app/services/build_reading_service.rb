class BuildReadingService
  def initialize(thermostat)
    @thermostat = thermostat
  end

  def call(attributes)
    reading = @thermostat.readings.build(attributes)
    @thermostat.update_stats(reading)
    CreateReadingJob.perform_later(reading.attributes.as_json)

    key = "thermostats/#{reading.thermostat_id}/readings/#{reading.number}"
    Rails.cache.write(key, reading.attributes, expires_in: 1.hour)

    reading
  end
end
