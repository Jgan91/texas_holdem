class AdjustStage < ActiveRecord::Migration[5.0]
  def change
    change_table :games do |t|
      t.remove :stage
      t.string :stage
    end
  end
end
