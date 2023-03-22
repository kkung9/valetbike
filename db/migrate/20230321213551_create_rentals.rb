class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.datetime :startTime
      t.datetime :predictedEndTime
      t.datetime :actualEndTime
      t.float :predictedFee
      t.float :actualFee

      t.timestamps
    end
  end
end
