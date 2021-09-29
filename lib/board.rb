require_relative './display.rb'

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
