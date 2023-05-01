class Station < ApplicationRecord
  has_many :docks
  has_many :bikes, through: :docks

  private

  # ensures that the photo file that is being accessed exists and throws an error if not.
  def photo_file_exists
    if photo.present?
      if !File.exist?("app/assets/images/"+photo) 
        errors.add(:photo, "file does not exist")
      end
    end
  end

end
