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
    end
  end
end
