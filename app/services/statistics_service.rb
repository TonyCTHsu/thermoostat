class StatisticsService
  def initialize(thermostat)
    @stats = thermostat.stats.value
  end

  def call
    {
      temperature: temperature_data,
      humidity: humidity_data,
      battery_charge: battery_charge_data,
    }
  end

  private

  def counter
    @stats['counter'].to_i
  end

  def temperature_data
    {
      max: @stats['max_temperature'].to_f,
      min: @stats['min_temperature'].to_f,
      average: @stats['temperature'].to_f/counter
    }
  end

  def humidity_data
    {
      max: @stats['max_humidity'].to_f,
      min: @stats['min_humidity'].to_f,
      average: @stats['humidity'].to_f/counter
    }
  end

  def battery_charge_data
    {
      max: @stats['max_humidity'].to_f,
      min: @stats['min_humidity'].to_f,
      average: @stats['humidity'].to_f/counter
    }
  end
end
