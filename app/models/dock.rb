class Dock < ApplicationRecord
  belongs_to :bike, optional: true
  belongs_to :station

  # removes association between bike object and dock object.
  def undock
    self.update(bike: nil)
  end

  # creates association between bike object and dock object.
  def redock(b)
    self.update_attribute(:bike, b)
  end

  private

  # ensures that the bike is not an active rental while simultaneously being docked.
  def bike_is_not_in_both_active_rental_and_dock
    if bike.present?
      if bike.rental.where(is_complete: nil).count >= 1
        errors.add(:bike, "cannot be in both active rental and dock")
      end
    end
  end

end
