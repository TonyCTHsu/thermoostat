describe ReadingsFetcher do
  describe '#call' do
    context 'cache hit' do
      it 'returns a reading from cache' do
        thermostat = double
        expect(ReadingsCache).to receive(:read).with(thermostat, 321).and_return(humidity: 1.1)

        result = described_class.new(thermostat).call(321)

        expect(result).to be_a Reading
        expect(result.humidity).to eq(1.1)
      end
    end

    context 'cache missed' do
      it 'returns a reading from database' do
        thermostat = create(:thermostat)
        reading = create(:reading, thermostat: thermostat)
        expect(ReadingsCache).to receive(:read).with(thermostat, reading.number)

        result = described_class.new(thermostat).call(reading.number)

        expect(result).to eq(reading)
      end
    end
  end
end
