class AddIsCompleteToRentals < ActiveRecord::Migration[7.0]
  def change
    add_column :rentals, :is_complete, :boolean
  end
end
