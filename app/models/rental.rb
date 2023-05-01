class Rental < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :bike, optional: true

  private

  # ensures that the bike is not an active rental while simultaneously being docked.
  def bike_is_not_in_both_active_rental_and_dock
    if bike.rental.where(is_complete: nil).count >= 1 || bike.dock.present?
      errors.add(:bike, "cannot be in both active rental and dock")
    end
  end

  # ensures that the rental's predicted end time occurs after the rental's start time.
  def predicted_end_time_after_start_time
    if predicted_end_time.present?
      if predicted_end_time < start_time
        errors.add(:predicted_end_time, "must be after the start time")
      end
    end
  end

  # ensures that the rental's actual end time (predicted end time plus overtime) occurs after the rental's start time.
  def actual_end_time_after_start_time
    if actual_end_time.present?
      if actual_end_time < start_time
        errors.add(:actual_end_time, "must be after the start time")
      end
    end
  end
  
end
