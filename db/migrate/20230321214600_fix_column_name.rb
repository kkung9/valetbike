class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :bikes, :current_station_id, :dock_id;
  end
end
