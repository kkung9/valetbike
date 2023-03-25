class AddBikeIdToDocks < ActiveRecord::Migration[7.0]
  def change
    # add_reference :docks, :bike, null: false, foreign_key: true
  end
end
