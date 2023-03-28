class AddIdentifierToBikes < ActiveRecord::Migration[7.0]
  def change
    add_column :bikes, :identifier, :integer
  end
end
