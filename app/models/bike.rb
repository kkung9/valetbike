class Bike < ApplicationRecord
  has_one :dock
  has_one :station, through: :dock

  has_one :rental
  has_one :user, through: :rental
end
