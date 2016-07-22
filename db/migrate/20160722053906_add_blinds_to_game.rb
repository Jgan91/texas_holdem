class AddBlindsToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :blinds, :boolean, default: true
  end
end
