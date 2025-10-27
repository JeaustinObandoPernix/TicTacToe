class Game < ApplicationRecord
  # Validaciones
  validates :player1, presence: true
  validates :player2, presence: true
  validates :status, inclusion: { in: %w[active completed draw] }, allow_nil: true
  validates :player1_symbol, inclusion: { in: %w[X O] }
  validates :player2_symbol, inclusion: { in: %w[X O] }
  validates :starting_player, inclusion: { in: %w[X O] }
  validates :game_type, inclusion: { in: %w[human ai] }, allow_nil: true
  validate :different_symbols
  validate :status_valid_after_creation

  # Callbacks
  before_create :initialize_board
  before_create :set_default_status
  before_create :set_default_symbols

  # Constantes
  BOARD_SIZE = 3
  PLAYERS = [ "X", "O" ]

  # Métodos de instancia
  def initialize_board
    self.board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, "") }.to_json
  end

  def set_default_status
    self.status = "active"
  end

  def set_default_symbols
    # Si no se especifican símbolos, asignar por defecto
    self.player1_symbol ||= "X"
    self.player2_symbol ||= "O"
    self.starting_player ||= "X"
  end

  def board_array
    JSON.parse(board)
  end

  def make_move(row, col, player)
    return false unless valid_move?(row, col)

    board_data = board_array
    board_data[row][col] = player
    self.board = board_data.to_json

    if check_winner?(player)
      self.winner = player
      self.status = "completed"
    elsif board_full?
      self.status = "draw"
    end

    save
  end

  def valid_move?(row, col)
    return false unless status == "active"
    return false unless row.between?(0, BOARD_SIZE - 1) && col.between?(0, BOARD_SIZE - 1)

    board_data = board_array
    board_data[row][col].blank?
  end

  def check_winner?(player)
    board_data = board_array

    # Verificar filas
    (0...BOARD_SIZE).each do |row|
      return true if board_data[row].all? { |cell| cell == player }
    end

    # Verificar columnas
    (0...BOARD_SIZE).each do |col|
      return true if (0...BOARD_SIZE).all? { |row| board_data[row][col] == player }
    end

    # Verificar diagonales
    return true if (0...BOARD_SIZE).all? { |i| board_data[i][i] == player }
    return true if (0...BOARD_SIZE).all? { |i| board_data[i][BOARD_SIZE - 1 - i] == player }

    false
  end

  def board_full?
    board_data = board_array
    board_data.flatten.none?(&:blank?)
  end

  def current_player
    board_data = board_array
    x_count = board_data.flatten.count("X")
    o_count = board_data.flatten.count("O")
    x_count <= o_count ? "X" : "O"
  end

  def current_player_name
    current_symbol = current_player
    if current_symbol == player1_symbol
      player1
    else
      player2
    end
  end

  def get_player_name(symbol)
    if symbol == player1_symbol
      player1
    elsif symbol == player2_symbol
      player2
    else
      "Desconocido"
    end
  end

  def game_over?
    status != "active"
  end

  def winner_name
    return nil unless winner
    get_player_name(winner)
  end

  def restart_game
    # Reiniciar el tablero a estado vacío
    self.board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, "") }.to_json

    # Restablecer el estado del juego
    self.status = "active"
    self.winner = nil

    # Guardar los cambios
    save
  end

  def game_type
    read_attribute(:game_type) || "human"
  end

  def ai_game?
    game_type == "ai"
  end

  def ai_symbol
    return nil unless ai_game?
    # La IA es siempre el player2 (Máquina)
    player2_symbol
  end

  def is_ai_player?(symbol)
    ai_game? && symbol == ai_symbol
  end

  def make_ai_move
    return false unless ai_game?
    return false if game_over?
    return false unless is_ai_player?(current_player)

    # Intentar estrategia: ganar, bloquear, o aleatorio
    move = find_winning_move || find_blocking_move || find_random_move
    return false unless move

    make_move(move[:row], move[:col], current_player)
  end

  private

  def different_symbols
    if player1_symbol == player2_symbol
      errors.add(:player2_symbol, "debe ser diferente al símbolo del jugador 1")
    end
  end

  def status_valid_after_creation
    if persisted? && !%w[active completed draw].include?(status)
      errors.add(:status, "debe ser 'active', 'completed' o 'draw'")
    end
  end

  def find_winning_move
    # Buscar si podemos ganar en el siguiente movimiento
    board_data = board_array
    ai_sym = ai_symbol

    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        if board_data[row][col].blank?
          # Simular el movimiento
          board_data[row][col] = ai_sym
          if check_winner_for_board?(board_data, ai_sym)
            board_data[row][col] = ""  # Revertir
            return { row: row, col: col }
          end
          board_data[row][col] = ""  # Revertir
        end
      end
    end
    nil
  end

  def find_blocking_move
    # Buscar si el oponente puede ganar y bloquear
    board_data = board_array
    opponent_sym = player1_symbol

    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        if board_data[row][col].blank?
          # Simular movimiento del oponente
          board_data[row][col] = opponent_sym
          if check_winner_for_board?(board_data, opponent_sym)
            board_data[row][col] = ""  # Revertir
            return { row: row, col: col }
          end
          board_data[row][col] = ""  # Revertir
        end
      end
    end
    nil
  end

  def find_random_move
    board_data = board_array
    available_moves = []

    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        available_moves << { row: row, col: col } if board_data[row][col].blank?
      end
    end

    available_moves.sample
  end

  def check_winner_for_board?(board_data, player)
    # Verificar filas
    (0...BOARD_SIZE).each do |row|
      return true if board_data[row].all? { |cell| cell == player }
    end

    # Verificar columnas
    (0...BOARD_SIZE).each do |col|
      return true if (0...BOARD_SIZE).all? { |row| board_data[row][col] == player }
    end

    # Verificar diagonales
    return true if (0...BOARD_SIZE).all? { |i| board_data[i][i] == player }
    return true if (0...BOARD_SIZE).all? { |i| board_data[i][BOARD_SIZE - 1 - i] == player }

    false
  end
end
