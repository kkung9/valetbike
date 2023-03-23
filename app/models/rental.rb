class Rental < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :bike, optional: true
end
