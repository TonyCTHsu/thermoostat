# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

thermostat = Thermostat.create(household_token: 'household_token', location: 'location')

thermostat.readings.create(number: 1, temperature: 1.1, humidity: 2.2, battery_charge: 3.3)
