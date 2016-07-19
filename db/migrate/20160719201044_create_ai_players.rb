class CreateAiPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :ai_players do |t|
      t.string :username

      t.timestamps
    end
  end
end
