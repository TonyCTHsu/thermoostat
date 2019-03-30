require 'rails_helper'

describe Thermostat do
  describe '#present_stats' do
    it do
      service = double(call: :updated)
      thermostat = described_class.new(id: 1)
      reading = double
      expect(UpdateStatsService).to receive(:new).with(thermostat).and_return(service)

      result = thermostat.update_stats(reading)

      expect(result).to eq(:updated)
      expect(service).to have_received(:call).with(reading)
    end
  end

  describe '#present_stats' do
    it do
      reporter = double(call: :report)
      thermostat = described_class.new
      expect(StatsReporter).to receive(:new).with(thermostat).and_return(reporter)

      result = thermostat.present_stats

      expect(result).to eq(:report)
      expect(reporter).to have_received(:call)
    end
  end

  describe '#generate_reading' do
    it do
      generator = double(call: :reading)
      attributes = double
      thermostat = described_class.new
      expect(ReadingGenerator).to receive(:new).with(thermostat).and_return(generator)

      result = thermostat.generate_reading(attributes)

      expect(result).to eq(:reading)
      expect(generator).to have_received(:call).with(attributes)
    end
  end

  describe '#fetch_reading' do
    it do
      fetcher = double(call: :reading)
      thermostat = described_class.new
      expect(ReadingsFetcher).to receive(:new).with(thermostat).and_return(fetcher)

      result = thermostat.fetch_reading(123123)

      expect(result).to eq(:reading)
      expect(fetcher).to have_received(:call).with(123123)
    end
  end
end
