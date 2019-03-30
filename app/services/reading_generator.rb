class ReadingGenerator
  def initialize(thermostat)
    @thermostat = thermostat
  end

  def call(attributes)
    @thermostat.readings.build(attributes).tap do |reading|
      @thermostat.update_stats(reading)
      CreateReadingJob.perform_later(reading.attributes)
      ReadingsCache.store(reading)
    end
  end
end
