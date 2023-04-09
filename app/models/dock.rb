class Dock < ApplicationRecord
  belongs_to :bike, optional: true
  belongs_to :station

  def undock
    self.update(bike: nil)
  end

  def redock(b)
    self.update(bike: b)
  end
end
