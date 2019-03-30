describe StatsReporter do
  describe '#call' do
    it do
      stats = {
        'max_temperature' => '21.2',
        'min_temperature' => '10.2',
        'max_humidity' => '10.2',
        'min_humidity' => '5.2',
        'max_battery_charge' => '10.2',
        'min_battery_charge' => '4.2',
        'counter' => '2',
        'temperature' => '100.2',
        'humidity' => '200.2',
        'battery_charge' => '300.2'
      }
      thermostat = double
      allow(thermostat).to receive_message_chain(:stats, :value).and_return(stats)

      result = described_class.new(thermostat).call

      expect(result).to eq(
        temperature: {
          max: 21.2,
          min: 10.2,
          average: 50.1
        },
        humidity: {
          max: 10.2,
          min: 5.2,
          average: 100.1
        },
        battery_charge: {
          max: 10.2,
          min: 4.2,
          average: 150.1
        }
      )
    end
  end
end
