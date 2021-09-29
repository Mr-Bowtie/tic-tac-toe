require_relative './display.rb'

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
