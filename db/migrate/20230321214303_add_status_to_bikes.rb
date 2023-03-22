class AddStatusToBikes < ActiveRecord::Migration[7.0]
  def change
    add_column :bikes, :status, :string
  end
end
