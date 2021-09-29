require_relative './board.rb'
require_relative './display.rb'
require_relative './game.rb'
require_relative './player.rb'
require_relative './computer.rb'

board = Board.new
human = Player.new(board)
computer = Computer.new(board)
tic_tac_toe = Game.new(board, human, computer)

tic_tac_toe.welcome
human.get_name

loop do
  tic_tac_toe.play_round
  tic_tac_toe.display_round_outcome

  if tic_tac_toe.play_again?
    human.reset_player
    computer.reset_player
    board.reset_board
  else
    break
  end
end

tic_tac_toe.display_game_over
