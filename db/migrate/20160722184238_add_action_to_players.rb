class AddActionToPlayers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :action, default: 0
    end

    change_table :ai_players do |t|
      t.integer :action, default: 0
    end
  end
end
