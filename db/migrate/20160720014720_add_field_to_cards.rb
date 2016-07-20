class AddFieldToCards < ActiveRecord::Migration[5.0]
  def change
    change_table :cards do |t|
      t.integer :ai_player_id
      t.integer :user_id
    end
  end
end
