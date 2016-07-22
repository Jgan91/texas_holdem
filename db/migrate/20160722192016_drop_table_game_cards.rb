class DropTableGameCards < ActiveRecord::Migration[5.0]
  def change
    drop_table :game_cards
  end
end
