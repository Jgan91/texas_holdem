class AddBetStyleToAiPlayers < ActiveRecord::Migration[5.0]
  def change
    change_table :ai_players do |t|
      t.string :bet_style
    end
  end
end
