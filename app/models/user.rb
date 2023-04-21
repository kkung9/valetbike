class User < ApplicationRecord
    has_many :rentals
    has_many :bikes, through: :rentals

end
