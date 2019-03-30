module Thermoostat
  class API < Grape::API
    format :json
    prefix :api

    resources :thermostats do
      route_param :id do
        desc 'Returns stats from a thermostat'
        get '/stats' do
          thermostat = Thermostat.find(params[:id])

          StatisticsService.new(thermostat).call
        end

        desc 'Returns a reading.'
        get '/readings/:reading_id' do
          thermostat = Thermostat.find(params[:id])

          reading = thermostat.fetch_reading(params[:reading_id])

          present reading, with: Entities::Reading
        end

        desc 'Create a reading'
        params do
          requires :temperature, type: Float
          requires :humidity, type: Float
          requires :battery_charge, type: Float
        end
        post '/readings' do
          thermostat = Thermostat.find(params[:id])

          reading = BuildReadingService.new(thermostat).call(declared(params))

          present reading, with: Entities::Reading
        end
      end
    end
  end
end
