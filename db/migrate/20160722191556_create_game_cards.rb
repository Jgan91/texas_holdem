class CreateGameCards < ActiveRecord::Migration[5.0]
  def change
    create_table :game_cards do |t|
      t.string :suit
      t.string :value
      t.string :image
    end
  end
end
