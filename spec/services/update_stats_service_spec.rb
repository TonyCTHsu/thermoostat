describe UpdateStatsService do
  describe '#call' do
    it do
      reading = build(:reading, number: nil, temperature: 1.5, humidity: 2.5, battery_charge: 3.5)
      thermostat = build(:thermostat, id: 1)
      service = described_class.new(thermostat)

      service.call(reading)

      expect(reading.number).to eq(1)
      expect(thermostat.stats.all).to eq(
        {
          "temperature" => "1.5",
          "humidity" => "2.5",
          "battery_charge" => "3.5",
          "counter" => "1",
          "max_temperature" => "1.5",
          "min_temperature" => "1.5",
          "max_humidity" => "2.5",
          "min_humidity" => "2.5",
          "max_battery_charge" => "3.5",
          "min_battery_charge" => "3.5"
        }
      )

      reading = build(:reading, number: nil, temperature: 1.5, humidity: 1.0, battery_charge: 4.5)
      service.call(reading)

      expect(reading.number).to eq(2)
      expect(thermostat.stats.all).to eq(
        {
          "temperature" => "3",
          "humidity" => "3.5",
          "battery_charge" => "8",
          "counter" => "2",
          "max_temperature" => "1.5",
          "min_temperature" => "1.5",
          "max_humidity" => "2.5",
          "min_humidity" => "1.0",
          "max_battery_charge" => "4.5",
          "min_battery_charge" => "3.5"
        }
      )
    end
  end
end
