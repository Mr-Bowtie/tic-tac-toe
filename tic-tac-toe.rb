# frozen_string_literal: true

require 'pry'

module Display
  def prompt(input)
    puts "==:| #{input}"
  end
end

class Board
  include Display
  WINNING_POSITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze
  attr_reader :size, :valid_positions
  attr_accessor :board_positions

  def initialize(size = 3)
    @size = size
    @board_positions = (1..(size ** 2)).to_a
  end

  def calc_valid_positions
    board_positions.select { |el| (1..(size ** 2)).include?(el) }
  end

  def display_middle_separator
    puts '|     |     |     | '
    puts '-------------------'
    puts '|     |     |     | '
  end

  def display_top_separator
    puts ''
    puts '-------------------'
    puts '|     |     |     | '
  end

  def display_bottom_separator
    puts '|     |     |     | '
    puts '-------------------'
    puts ''
  end

  def display_boxes(s1, s2, s3)
    boxes = [s1, s2, s3]
    boxes.each do |s|
      boxes[boxes.index(s)] = if s.is_a?(Integer)
          "[#{s}]"
        else
          " #{s} "
        end
    end
    puts "| #{boxes[0]} | #{boxes[1]} | #{boxes[2]} |"
  end

  def display_board
    display_top_separator
    display_boxes(@board_positions[0], @board_positions[1], @board_positions[2])
    display_middle_separator
    display_boxes(@board_positions[3], @board_positions[4], @board_positions[5])
    display_middle_separator
    display_boxes(@board_positions[6], @board_positions[7], @board_positions[8])
    display_bottom_separator
  end

  def board_full?
    calc_valid_positions.empty?
  end

  def reset_board
    self.board_positions = (1..(size ** 2)).to_a
  end
end

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

class Computer < Player
  include Display
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

class Game
  include Display
  attr_accessor :board, :player1, :player2

  def initialize(board, player1, player2)
    @board = board
    @player1 = player1
    @player2 = player2
  end

  def welcome
    system('clear')
    prompt 'Welcome to Tic-Tac-Toe, lets play!'
  end

  def play_round
    loop do
      system('clear')
      board.display_board
      player1.turn_action
      break if player1.winner? || board.board_full?

      player2.turn_action
      break if player2.winner? || board.board_full?
    end
    system('clear')
    board.display_board
  end

  def display_round_outcome
    if player1.winner
      prompt "#{player1.name} Wins!"
    elsif player2.winner
      prompt "#{player2.name} Wins!"
    else
      prompt 'Cat Scratch'
    end
  end

  def play_again?
    prompt 'Would you like to play again? ( yes | no )'
    loop do
      choice = gets.chomp.downcase
      if valid_choice?(choice)
        case choice
        when 'yes', 'y'
          return true
        when 'no', 'n'
          return false
        end
      end
      prompt 'Invalid input. Valid options: yes, y, no, n'
    end
  end

  def valid_choice?(choice)
    %w[yes y no n].include?(choice)
  end

  def display_game_over
    prompt "Thanks for playing Tic-Tac-Toe, Goodbye #{player1.name}!"
  end

  def display_player_symbols; end
end

# board = Board.new
# human = Player.new(board)
# computer = Computer.new(board)
# tic_tac_toe = Game.new(board, human, computer)

# tic_tac_toe.welcome
# human.get_name

# loop do
#   tic_tac_toe.play_round
#   tic_tac_toe.display_round_outcome

#   if tic_tac_toe.play_again?
#     human.reset_player
#     computer.reset_player
#     board.reset_board
#   else
#     break
#   end
# end

# tic_tac_toe.display_game_over
