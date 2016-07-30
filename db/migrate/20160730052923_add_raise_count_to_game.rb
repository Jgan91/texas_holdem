class AddRaiseCountToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :raise_count, :integer, default: 0
  end
end
