class Station < ApplicationRecord
  validates_presence_of    :identifier,
                           :name,
                           :address
  validates_uniqueness_of  :identifier
  
  has_many :docks
  has_many :bikes, through: :docks
end
