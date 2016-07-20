class AddTotalBetToAi < ActiveRecord::Migration[5.0]
  def change
    add_column :ai_players, :total_bet, :integer, default: 0
  end
end
