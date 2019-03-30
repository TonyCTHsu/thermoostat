class CreateThermostat < ActiveRecord::Migration[5.2]
  def change
    create_table :thermostats do |t|
      t.text :household_token
      t.text :location
    end

    create_table :readings do |t|
      t.integer :number, null: false, index: true
      t.float :temperature
      t.float :humidity
      t.float :battery_charge
      t.references :thermostat, foreign_key: true
    end
  end
end
