class AddPotToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :pot, :integer, default: 0
  end
end
