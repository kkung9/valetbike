class Station < ApplicationRecord
  validates_presence_of    :identifier,
                           :name,
                           :address
  validates_uniqueness_of  :identifier
  validates_length_of :identifier, is: 2
  
  has_many :docks
  has_many :bikes, through: :docks
  
end
