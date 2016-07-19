class AddGameIdToAis < ActiveRecord::Migration[5.0]
  def change
    change_table :ai_players do |t|
      t.integer :game_id
    end
  end
end
