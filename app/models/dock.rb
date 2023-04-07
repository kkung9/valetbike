class Dock < ApplicationRecord
  belongs_to :bike, optional: true
  belongs_to :station

  def undock
    self.bike.dock_id = nil
    self.bike = nil
  end
end
