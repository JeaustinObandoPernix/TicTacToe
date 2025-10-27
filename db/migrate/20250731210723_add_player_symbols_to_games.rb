class AddPlayerSymbolsToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :player1_symbol, :string
    add_column :games, :player2_symbol, :string
    add_column :games, :starting_player, :string
  end
end
