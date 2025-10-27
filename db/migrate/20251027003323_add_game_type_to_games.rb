class AddGameTypeToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :game_type, :string
  end
end
