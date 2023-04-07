class Station < ApplicationRecord
  validates_presence_of    :identifier,
                           :name,
                           :address
  validates_uniqueness_of  :identifier
  
  has_many :docks
  has_many :bikes, through: :docks

  # def search
  #   if params[:search].blank?
  #     @results = Station.all
  #   else
  #     @parameters = params[:search].downcase
  #     @results = Station.all.where("lower(name) LIKE :search", search: "%{@parameter}")
  #   end
  # end
  
end
