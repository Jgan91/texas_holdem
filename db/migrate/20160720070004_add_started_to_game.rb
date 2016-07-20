class AddStartedToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :started, :boolean, default: false
  end
end
