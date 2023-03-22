class Dock < ApplicationRecord
  belongs_to :bike, optional: true
  belongs_to :station, optional: true
end
