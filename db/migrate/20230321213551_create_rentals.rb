class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.datetime :start_time
      t.datetime :predicted_end_time
      t.datetime :actual_end_time
      t.float :predicted_fee
      t.float :actual_fee
      t.integer :start_station
      t.integer :end_station

      t.timestamps
    end
  end
end
