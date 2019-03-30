class Thermoostat::Entities::Reading < Grape::Entity
  expose :number
  expose :temperature
  expose :humidity
  expose :battery_charge
end
