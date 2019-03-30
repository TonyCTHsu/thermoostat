class Reading < ApplicationRecord
  belongs_to :thermostat

  def to_params
    number.to_s
  end
end
