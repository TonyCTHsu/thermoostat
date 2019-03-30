class Thermostat < ApplicationRecord
  include Redis::Objects
  lock :statistic
  hash_key :stats

  has_many :readings

  def update_stats(reading)
    statistic_lock.lock do
      UpdateStatsService.new(self).call(reading)
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
