class AddIdentifierToDocks < ActiveRecord::Migration[7.0]
  def change
    add_column :docks, :identifier, :integer
  end
end
