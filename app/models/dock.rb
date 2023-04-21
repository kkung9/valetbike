class Dock < ApplicationRecord
  belongs_to :bike, optional: true
  belongs_to :station

  validate :bike_is_not_in_both_active_rental_and_dock

  def undock
    self.update(bike: nil)
  end

  def redock(b)
    self.update(bike: b)
  end

  private

  def bike_is_not_in_both_active_rental_and_dock
    if bike.nil? == false
      if bike.rental.where(is_complete: nil).count >= 1
        errors.add(:description, "cannot be in both active rental and dock")
      end
    end
  end

end
