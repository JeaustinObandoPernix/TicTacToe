class GamesController < ApplicationController
  before_action :set_game, only: [ :show, :update, :move, :restart ]

  def index
    @games = Game.all.order(created_at: :desc)
  end

  def show
    @board = @game.board_array
    @current_player = @game.current_player
    @current_player_name = @game.current_player_name
    @game_over = @game.game_over?
    @is_ai_turn = @game.ai_game? && @game.is_ai_player?(@current_player) && !@game_over
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    # Si es modo AI, establecer player2 como "Máquina"
    if @game.game_type == "ai"
      @game.player2 = "Máquina"
    end

    if @game.save
      redirect_to @game, notice: "Partida creada exitosamente!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def move
    row = params[:row].to_i
    col = params[:col].to_i
    player = params[:player]

    if @game.make_move(row, col, player)
      # Verificar si el juego terminó después del movimiento del jugador
      if @game.game_over?
        winner_name = @game.winner_name
        message = @game.winner ? "¡#{winner_name} ha ganado!" : "¡Empate!"
        redirect_to @game, notice: message
        return
      end

      # Si es modo AI y es turno de la IA, hacer su movimiento
      if @game.ai_game? && @game.is_ai_player?(@game.current_player) && !@game.game_over?
        @game.make_ai_move

        if @game.game_over?
          winner_name = @game.winner_name
          message = @game.winner ? "¡#{winner_name} ha ganado!" : "¡Empate!"
          redirect_to @game, notice: message
          return
        end
      end

      redirect_to @game, notice: "Movimiento realizado"
    else
      redirect_to @game, alert: "Movimiento inválido"
    end
  end

  def restart
    if @game.restart_game
      redirect_to @game, notice: "¡Juego reiniciado exitosamente! El tablero se ha limpiado."
    else
      redirect_to @game, alert: "Error al reiniciar el juego"
    end
  end

  def update
    # Esta acción se mantiene para compatibilidad con REST
    move
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:player1, :player2, :player1_symbol, :player2_symbol, :starting_player, :game_type)
  end
end
