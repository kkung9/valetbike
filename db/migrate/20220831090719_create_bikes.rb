class CreateBikes < ActiveRecord::Migration[7.0]
    def change
      create_table :bikes do |t|
        t.integer :identifier
        # t.integer :dock_id
        t.string :status
  
        t.timestamps
      end
    end
  end