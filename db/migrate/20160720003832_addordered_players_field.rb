class AddorderedPlayersField < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :ordered_players, :string, array: true, default: []
  end
end
