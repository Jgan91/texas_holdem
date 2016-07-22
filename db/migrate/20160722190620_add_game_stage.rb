class AddGameStage < ActiveRecord::Migration[5.0]
  def change
    change_table :games do |t|
      t.remove :blinds
      t.string :stage
    end
  end
end
