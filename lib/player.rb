require_relative './display.rb'
require_relative './board.rb'

class Player
  include Display
  attr_accessor :board, :symbol, :first_move, :winner, :name, :score

  def initialize(board)
    @name = ''
    @score = 0
    @first_move = false
    @board = board
    @symbol = 'X'
    @winner = false
  end

  def get_name
    prompt 'What is your name?'
    choice = gets.chomp
    self.name = choice
  end

  def go_first
    self.first_move = true
    self.symbol = 'X'
  end

  def turn_action
    prompt "Choose an open position on the board #{board.calc_valid_positions}"
    loop do
      choice = gets.chomp.to_i
      position = board.board_positions.index(choice)
      if valid_action?(choice)
        board.board_positions[position] = symbol
        break
      else
        prompt "Invalid input: Choose a valid position #{board.calc_valid_positions}"
      end
    end
  end

  def valid_action?(move)
    board.calc_valid_positions.include?(move)
  end

  def winner?
    positions = board.board_positions
    Board::WINNING_POSITIONS.each do |group|
      return self.winner = true if group.all? { |i| positions[i - 1] == symbol }
    end
    false
  end

  def reset_player
    self.winner = false
    self.score = 0
    self.first_move = false
  end
end
