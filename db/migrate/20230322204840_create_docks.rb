class CreateDocks < ActiveRecord::Migration[7.0]
  def change
    create_table :docks do |t|
      t.references :bike, null: true, foreign_key: false
      t.references :station, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
