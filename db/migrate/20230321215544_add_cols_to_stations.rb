class AddColsToStations < ActiveRecord::Migration[7.0]
  def change
    add_column :stations, :photo, :string
    add_column :stations, :description, :string
  end
end
