class User < ApplicationRecord
    has_many :rentals
    has_many :bikes, through: :rentals

    # EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

    # validates_presence_of   :first_name,
    #                         :last_name
    # validates_uniqueness_of  :identifier
    # validates :email, presence: true, length: { maximum: 100 }, uniqueness: true, format: { with: EMAIL_REGEX }

end
