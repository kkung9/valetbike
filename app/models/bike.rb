class Bike < ApplicationRecord
  validates_presence_of    :identifier

  has_one :dock
  has_one :station, through: :dock

  has_many :rental
  has_many :user, through: :rental

  # current_user = Bike.user.where(is_complete: false) 
  # puts(current_user.id)
  # return current_user.id 

end
