FactoryBot.define do
  factory :reading do
    thermostat
    sequence(:number)
    temperature { 1.1 }
    humidity { 2.2 }
    battery_charge { 3.3 }
  end
end
