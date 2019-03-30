require 'rails_helper'

describe ReadingGenerator do
  describe '#call' do
    it do
      expect(CreateReadingJob).to receive(:perform_later).with(hash_including('humidity' => 1.1))
      allow(ReadingsCache).to receive(:store)
      thermostat = create(:thermostat)
      allow(thermostat).to receive(:update_stats)

      result = described_class.new(thermostat).call(humidity: 1.1)

      expect(result).to be_a Reading
      expect(result.humidity).to eq(1.1)
      expect(thermostat).to have_received(:update_stats).with(result).once
      expect(ReadingsCache).to have_received(:store).with(result).once
    end
  end
end
