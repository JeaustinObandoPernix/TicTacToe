# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creando partidas de ejemplo..."

# Limpiar partidas existentes
Game.destroy_all

# Crear algunas partidas de ejemplo
games_data = [
  {
    player1: "Ana",
    player2: "Carlos",
    player1_symbol: "X",
    player2_symbol: "O",
    starting_player: "X",
    status: "completed",
    winner: "X",
    board: [["X", "O", "X"], ["O", "X", "O"], ["X", "", ""]].to_json
  },
  {
    player1: "María",
    player2: "Juan",
    player1_symbol: "O",
    player2_symbol: "X",
    starting_player: "X",
    status: "draw",
    winner: nil,
    board: [["X", "O", "X"], ["O", "X", "O"], ["O", "X", "O"]].to_json
  },
  {
    player1: "Pedro",
    player2: "Laura",
    player1_symbol: "X",
    player2_symbol: "O",
    starting_player: "X",
    status: "active",
    winner: nil,
    board: [["X", "O", ""], ["", "X", ""], ["", "", ""]].to_json
  },
  {
    player1: "Sofía",
    player2: "Miguel",
    player1_symbol: "O",
    player2_symbol: "X",
    starting_player: "O",
    status: "active",
    winner: nil,
    board: [["O", "", ""], ["", "", ""], ["", "", ""]].to_json
  }
]

games_data.each do |game_data|
  Game.create!(game_data)
end

puts "¡Partidas de ejemplo creadas exitosamente!"
puts "Total de partidas: #{Game.count}"
