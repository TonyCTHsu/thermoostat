class Thermostat < ApplicationRecord
  include Redis::Objects
  lock :statistic
  hash_key :stats

  has_many :readings

  def update_stats(reading)
    statistic_lock.lock do
      stats.incrbyfloat('temperature', reading.temperature)
      stats.incrbyfloat('humidity', reading.humidity)
      stats.incrbyfloat('battery_charge', reading.battery_charge)
      reading.number = stats.incr('counter')
      cached_boundries = stats.bulk_get(
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

      stats.bulk_set(new_boundries)
    end
  end

  def present_stats
    StatsReporter.new(self).call
  end

  def generate_reading(attributes)
    ReadingGenerator.new(self).call(attributes)
  end

  def fetch_reading(reading_number)
    ReadingsFetcher.new(self).call(reading_number)
  end
end
