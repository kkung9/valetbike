class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    if table_exists?(:bikes)
    else
      create_table :bikes do |t|
        t.string :status

        t.timestamps
      end
    end
  end
end
