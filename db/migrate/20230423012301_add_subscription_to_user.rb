class AddSubscriptionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subscription, :datetime
  end
end
