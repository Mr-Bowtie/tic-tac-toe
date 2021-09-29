require_relative './player.rb'

class Computer < Player
  attr_accessor :board, :name

  def initialize(board)
    super
    @symbol = 'O'
    @name = 'Computer '
  end

  def turn_action
    choice = board.calc_valid_positions.sample
    board.board_positions[choice - 1] = symbol
  end
end
