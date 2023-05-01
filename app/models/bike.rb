class Bike < ApplicationRecord
  validates_presence_of    :identifier

  has_one :dock
  has_one :station, through: :dock

  has_many :rental
  has_many :user, through: :rental

end
