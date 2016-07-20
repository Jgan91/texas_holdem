class AddTotalBettoUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :total_bet, default: 0
      t.integer :cash, default: 2000
    end
  end
end
