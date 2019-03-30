module Thermoostat
  class API < Grape::API
    format :json
    prefix :api

    helpers do
      def thermostat
        @thermostat ||= Thermostat.find(params[:id])
      end
    end

    resources :thermostats do
      route_param :id do
        desc 'Returns stats from a thermostat'
        get '/stats' do
          thermostat.present_stats
        end

        desc 'Returns a reading.'
        get '/readings/:reading_id' do
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
          reading = thermostat.generate_reading(declared(params))

          present reading, with: Entities::Reading
        end
      end
    end
  end
end
