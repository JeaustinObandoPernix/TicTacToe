class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :player1
      t.string :player2
      t.string :status
      t.text :board
      t.string :winner

      t.timestamps
    end
  end
end
