class Thermoostat::API < Grape::API
  format :json
  prefix :api

  resources :thermostats do
    route_param :id do
      get :stats do
      end
    end
  end
end
