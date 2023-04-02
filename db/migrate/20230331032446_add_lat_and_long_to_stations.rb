class AddLatAndLongToStations < ActiveRecord::Migration[7.0]
  def change
    add_column :stations, :lat, :float
    add_column :stations, :long, :float
  end
end
