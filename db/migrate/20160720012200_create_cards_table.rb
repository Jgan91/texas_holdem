class CreateCardsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :value
      t.string :suit
      t.string :image
    end
  end
end
