# TicTacToe

A beautiful web-based Tic Tac Toe game built with Ruby on Rails.

## Features

- **Multiplayer Mode**: Play against another person
- **AI Mode**: Play against an intelligent computer opponent
- Beautiful, responsive UI built with Bootstrap
- Real-time game updates
- Game history tracking

## How to Play

### Starting a New Game

1. Click on "Nueva Partida" (New Game)
2. Choose your game type:
   - **Contra otra persona** (Against another person): Traditional two-player mode
   - **Contra la Máquina** (Against the Machine): Play against AI
3. If playing against a person, enter both players' names
4. Select symbols (X or O) for each player
5. Choose who starts the game
6. Click "Crear Partida" to begin

### Game Rules

- Players take turns placing their symbol (X or O) on the board
- The first player to get three of their symbols in a row (horizontal, vertical, or diagonal) wins
- If all cells are filled without a winner, the game ends in a draw

### AI Opponent

The AI opponent has three levels of strategy:
1. **Win**: If the AI can win on this turn, it will make the winning move
2. **Block**: If the human player could win on their next turn, the AI will block them
3. **Random**: Otherwise, the AI makes a random available move

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   bin/rails db:create db:migrate
   ```
4. Start the server:
   ```bash
   bin/rails server
   ```
5. Open your browser and navigate to `http://localhost:3000`

## Technologies

- Ruby on Rails 7.2
- SQLite
- Bootstrap 5
- Font Awesome

## License

This project is open source and available under the MIT License.
