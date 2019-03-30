require 'rails_helper'

describe 'Thermoostat::API' do
  context 'GET /api/thermostats/:id/reading/:reading_id' do
    it 'returns stats' do
      thermostat = create(:thermostat)
      allow(Thermostat).to receive(:find).and_return(thermostat)
      expect(thermostat).to receive(:present_stats).and_return(
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

      get "/api/thermostats/#{thermostat.id}/stats",
          headers: { 'X-Household-Token' => thermostat.household_token }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        'temperature' => {
          'max' => 21.2,
          'min' => 10.2,
          'average' => 50.1
        },
        'humidity' => {
          'max' => 10.2,
          'min' => 5.2,
          'average' => 100.1
        },
        'battery_charge' => {
          'max' => 10.2,
          'min' => 4.2,
          'average' => 150.1
        }
      )
    end

    context 'when unauthorized' do
      it do
        thermostat = create(:thermostat)

        get "/api/thermostats/#{thermostat.id}/stats",
            headers: { 'X-Household-Token' => 'unauthorized_token' }

        expect(response.status).to eq(401)
      end
    end
  end

  context 'POST /api/thermostats/:id/readings' do
    it 'returns an posted reading' do
      thermostat = create(:thermostat)
      reading = build(:reading, thermostat: thermostat, number: 2)
      allow(Thermostat).to receive(:find).and_return(thermostat)
      expect(thermostat).to receive(:generate_reading).
        with(temperature: 1.1, humidity: 2.2, battery_charge: 3.3).and_return(reading)

      post "/api/thermostats/#{thermostat.id}/readings",
           params: { temperature: 1.1, humidity: 2.2, battery_charge: 3.3 },
           headers: { 'X-Household-Token' => thermostat.household_token }

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)).to eq(
        'number' => reading.number,
        'temperature' => reading.temperature,
        'humidity' => reading.humidity,
        'battery_charge' => reading.battery_charge
      )
    end

    context 'when unauthorized' do
      it do
        thermostat = create(:thermostat)

        post "/api/thermostats/#{thermostat.id}/readings",
             params: { temperature: 1.1, humidity: 2.2, battery_charge: 3.3 },
             headers: { 'X-Household-Token' => 'unauthorized_token' }

        expect(response.status).to eq(401)
      end
    end
  end

  context 'GET /api/thermostats/:id/reading/:reading_id' do
    it 'returns a reading' do
      thermostat = create(:thermostat)
      reading = build(:reading, thermostat: thermostat, number: 2)
      allow(Thermostat).to receive(:find).and_return(thermostat)
      expect(thermostat).to receive(:fetch_reading).with(reading.number.to_s).and_return(reading)

      get "/api/thermostats/#{thermostat.id}/readings/#{reading.number}",
          headers: { 'X-Household-Token' => thermostat.household_token }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        'number' => reading.number,
        'temperature' => reading.temperature,
        'humidity' => reading.humidity,
        'battery_charge' => reading.battery_charge
      )
    end

    context 'when unauthorized' do
      it do
        thermostat = create(:thermostat)
        reading = build(:reading, thermostat: thermostat, number: 2)

        get "/api/thermostats/#{thermostat.id}/readings/#{reading.number}",
            headers: { 'X-Household-Token' => 'unauthorized_token' }

        expect(response.status).to eq(401)
      end
    end
  end
end
