describe ReadingsCache do
  describe '.store' do
    it do
      reading = double(thermostat_id: 123, number: 321, attributes: {})
      cache = double(write: true)
      expect(Rails).to receive(:cache).and_return(cache)

      described_class.store(reading)

      expect(cache).to have_received(:write).with(
        'thermostats/123/readings/321',
        {},
        expires_in: 1.hour
      )
    end
  end

  describe '.read' do
    it do
      thermostat = double(id: 123)
      cache = double(read: :cached_result)
      expect(Rails).to receive(:cache).and_return(cache)

      result = described_class.read(thermostat, 321)

      expect(result).to eq(:cached_result)
      expect(cache).to have_received(:read).with('thermostats/123/readings/321')
    end
  end
end
