class Rental < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :bike, optional: true

    validate :bike_is_not_in_both_active_rental_and_dock

    private

    def bike_is_not_in_both_active_rental_and_dock
      if bike.rental.where(is_complete: nil).count >= 1 && bike.dock.present?
        errors.add(:description, "cannot be in both active rental and dock")
      end
    end
    
end
