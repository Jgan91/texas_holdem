class AddGameProperties < ActiveRecord::Migration[5.0]
  def change
    change_table :games do |t|
      t.integer :little_blind, default: 50
      t.integer :big_blind, default: 100
    end
  end
end
