class Rental < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :bike, optional: true

  # start_station and end_station store station_id (not station Obj)
  validate :bike_is_not_in_both_active_rental_and_dock
  validate :predicted_end_time_after_start_time
  validate :actual_end_time_after_start_time
  validates_presence_of :start_time
  validates_length_of :start_station, is: 2
  validates_length_of :end_station, is: 2, allow_blank: true
  validates_numericality_of :actual_fee, greater_than_or_equal_to: :predicted_fee, allow_blank: true

  private

  def bike_is_not_in_both_active_rental_and_dock
    if bike.rental.where(is_complete: nil).count >= 1 || bike.dock.present?
      errors.add(:bike, "cannot be in both active rental and dock")
    end
  end

  def predicted_end_time_after_start_time
    if predicted_end_time.present?
      if predicted_end_time < start_time
        errors.add(:predicted_end_time, "must be after the start time")
      end
    end
  end

  def actual_end_time_after_start_time
    if actual_end_time.present?
      if actual_end_time < start_time
        errors.add(:actual_end_time, "must be after the start time")
      end
    end
  end
  
end
