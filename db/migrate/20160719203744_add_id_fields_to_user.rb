class AddIdFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :game_id
    end
  end
end
