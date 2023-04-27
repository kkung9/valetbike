class Station < ApplicationRecord
  has_many :docks
  has_many :bikes, through: :docks

  validates_presence_of    :identifier,
                           :name,
                           :address
  validates_uniqueness_of  :identifier
  validates_length_of :identifier, is: 2
  validates_numericality_of :capacity, greater_than_or_equal_to: 1
  validate :photo_file_exists

  private

  def photo_file_exists
    if photo.present?
      if !File.exist?("app/assets/images/"+photo) 
        errors.add(:photo, "file does not exist")
      end
    end
  end

end
