require "pry"

module Display
  def prompt(input)
    puts "==:| #{input}"
  end
end

class Board
  include Display
  WINNING_POSITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
  attr_reader :size, :valid_positions
  attr_accessor :board_positions

  def initialize(size = 3)
    @size = size
    @board_positions = (1..(size ** 2)).to_a
  end

  def calc_valid_positions
    self.board_positions.select { |el| (1..(size ** 2)).include?(el) }
  end

  def display_middle_separator
    puts "|     |     |     | "
    puts "-------------------"
    puts "|     |     |     | "
  end

  def display_top_separator
    puts ""
    puts "-------------------"
    puts "|     |     |     | "
  end

  def display_bottom_separator
    puts "|     |     |     | "
    puts "-------------------"
    puts ""
  end

  def display_boxes(s1, s2, s3)
    boxes = [s1, s2, s3]
    boxes.each do |s|
      if s.is_a?(Integer)
        boxes[boxes.index(s)] = "[" + s.to_s + "]"
      else
        boxes[boxes.index(s)] = " " + s + " "
      end
    end
    puts "| #{boxes[0]} | #{boxes[1]} | #{boxes[2]} |"
  end

  def display_board
    display_top_separator()
    display_boxes(@board_positions[0], @board_positions[1], @board_positions[2])
    display_middle_separator()
    display_boxes(@board_positions[3], @board_positions[4], @board_positions[5])
    display_middle_separator()
    display_boxes(@board_positions[6], @board_positions[7], @board_positions[8])
    display_bottom_separator()
  end

  def board_full?
    self.calc_valid_positions.empty?
  end

  def reset_board
    self.board_positions = (1..(size ** 2)).to_a
  end
end

class Player
  include Display
  attr_accessor :board, :symbol, :first_move, :winner, :name, :score

  def initialize(board)
    @name = ""
    @score = 0
    @first_move = false
    @board = board
    @symbol = "X"
    @winner = false
  end

  def get_name
    prompt "What is your name?"
    choice = gets.chomp
    self.name = choice
  end

  def go_first
    self.first_move = true
    self.symbol = "X"
  end

  def turn_action
    prompt "Choose an open position on the board #{self.board.calc_valid_positions}"
    loop do
      choice = gets.chomp.to_i
      position = self.board.board_positions.index(choice)
      if valid_action?(choice)
        self.board.board_positions[position] = self.symbol
        break
      else
        prompt "Invalid input: Choose a valid position #{self.board.calc_valid_positions}"
      end
    end
  end

  def valid_action?(move)
    self.board.calc_valid_positions.include?(move)
  end

  def winner?
    positions = self.board.board_positions
    Board::WINNING_POSITIONS.each do |group|
      if group.all? { |i| positions[i - 1] == self.symbol }
        return self.winner = true
      end
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
    @symbol = "O"
    @name = "Computer "
  end

  def turn_action
    choice = self.board.calc_valid_positions.sample
    self.board.board_positions[choice - 1] = self.symbol
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
    system("clear")
    prompt "Welcome to Tic-Tac-Toe, lets play!"
  end

  def play_round
    loop do
      system("clear")
      self.board.display_board
      self.player1.turn_action
      if self.player1.winner? || self.board.board_full?
        break
      end
      self.player2.turn_action
      if self.player2.winner? || self.board.board_full?
        break
      end
    end
    system("clear")
    self.board.display_board
  end

  def display_round_outcome
    if self.player1.winner
      prompt "#{self.player1.name} Wins!"
    elsif self.player2.winner
      prompt "#{self.player2.name} Wins!"
    else
      prompt "Cat Scratch"
    end
  end

  def play_again?
    prompt "Would you like to play again? ( yes | no )"
    loop do
      choice = gets.chomp.downcase
      if valid_choice?(choice)
        if choice == "yes" || choice == "y"
          return true
        elsif choice == "no" || choice == "n"
          return false
        end
      end
      prompt "Invalid input. Valid options: yes, y, no, n"
    end
  end

  def valid_choice?(choice)
    %w(yes y no n).include?(choice)
  end

  def display_game_over
    prompt "Thanks for playing Tic-Tac-Toe, Goodbye #{self.player1.name}!"
  end

  def display_player_symbols
  end
end

board = Board.new
human = Player.new(board)
computer = Computer.new(board)
tic_tac_toe = Game.new(board, human, computer)

tic_tac_toe.welcome
human.get_name

loop do
  tic_tac_toe.play_round
  tic_tac_toe.display_round_outcome

  unless tic_tac_toe.play_again?
    break
  else
    human.reset_player
    computer.reset_player
    board.reset_board
  end
end

tic_tac_toe.display_game_over
