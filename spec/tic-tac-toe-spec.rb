require_relative '../lib/board.rb'
require_relative '../lib/computer.rb'
require_relative '../lib/game.rb'
require_relative '../lib/player.rb'

describe Game do
  describe '#play_round' do
    context 'when human has 3 in a row play ends' do
      let(:test_board) { instance_double(Board) }
      let(:test_human) { instance_double(Player) }
      let(:test_comp) { instance_double(Computer) }
      let(:game) { described_class.new(test_board, test_human, test_comp) }
      before do
        # board = game.instance_variable_get(:@board)
        # human = game.instance_variable_get(:@player1)
        # comp = game.instance_variable_get(:@player2)
        # allow(:system).to receive('clear')
        allow(test_board).to receive(:display_board)
        allow(test_human).to receive(:turn_action)
        allow(test_human).to receive(:winner?).and_return(true)
      end

      it 'stops loop and does not check if the board is full' do
        expect(test_board).not_to receive(:board_full?)
        game.play_round
      end
    end
  end
end
