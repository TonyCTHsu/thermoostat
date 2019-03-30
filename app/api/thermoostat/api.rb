module Thermoostat
  class API < Grape::API
    format :json
    prefix :api

    resources :thermostats do
      route_param :id do
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

        get :stats do
        end
      end
    end
  end
end
