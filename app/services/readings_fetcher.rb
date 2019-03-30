class ReadingsFetcher
  def initialize(thermostat)
    @thermostat = thermostat
  end

  def call(reading_number)
    cached_attributes = ReadingsCache.read(@thermostat, reading_number)

    if cached_attributes
      Reading.new(cached_attributes)
    else
      @thermostat.readings.find_by(number: reading_number)
    end
  end
end
