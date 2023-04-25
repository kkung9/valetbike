class AddSubscriptionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sub_id, :string
  end
end
