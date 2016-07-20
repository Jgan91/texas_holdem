class AddCashAttToAi < ActiveRecord::Migration[5.0]
  def change
    change_table :ai_players do |t|
      t.integer :cash, default: 1000
    end
  end
end
