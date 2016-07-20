class AddGameIdToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :game_id, :integer
  end
end
