class AddGameCardsToGame < ActiveRecord::Migration[5.0]
  def change
    change_table :games do |t|
      t.text :game_cards, array: true, default: []
    end
  end
end
