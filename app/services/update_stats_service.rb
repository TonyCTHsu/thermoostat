class UpdateStatsService
  def initialize(thermostat)
    @thermostat = thermostat
  end

  def call(reading)
    @thermostat.stats.incrbyfloat('temperature', reading.temperature)
    @thermostat.stats.incrbyfloat('humidity', reading.humidity)
    @thermostat.stats.incrbyfloat('battery_charge', reading.battery_charge)
    reading.number = @thermostat.stats.incr('counter')
    cached_boundries = @thermostat.stats.bulk_get(
      'max_temperature',
      'min_temperature',
      'max_humidity',
      'min_humidity',
      'max_battery_charge',
      'min_battery_charge'
    )

    new_boundries = cached_boundries.reduce({}) do |hash, (key, value)|
      operation, property = key.split(/_/, 2)
      hash[key] = [value, reading[property]].compact.map(&:to_f).__send__(operation)
      hash
    end

    @thermostat.stats.bulk_set(new_boundries)
  end
end
