# frozen_string_literal: true

require_relative '../player'
require_relative '../interface'
require_relative '../tictactoe'

describe Interface do
  let(:player1) { instance_double(Player) }
  let(:player2) { instance_double(Player) }

  describe '#do_turn' do
    # Public Script Method
    # Test the win condition if statement

    context 'when the line win pattern is completed by Player 1' do
      subject(:win_line) { described_class.new(player1, player2, 0) }

      before do
        allow(player1).to receive(:add_move)
        allow(win_line).to receive(:display)
        allow(win_line).to receive(:prompt)
        allow(player1).to receive(:player_moves).and_return(%w[A1 A2 A3])
      end

      it 'returns false to signal that the game should not continue' do
        p player1.player_moves
        expect(win_line.do_turn).to be false
      end
    end

    context 'when the diagonal win pattern is completed by Player 1' do
      subject(:win_diagonal) { described_class.new(player1, player2, 0) }

      before do
        allow(player1).to receive(:add_move)
        allow(win_diagonal).to receive(:display)
        allow(win_diagonal).to receive(:prompt)
        allow(player1).to receive(:player_moves).and_return(%w[A1 B2 C3])
      end

      it 'returns false to signal that the game should not continue' do
        p player1.player_moves
        expect(win_diagonal.do_turn).to be false
      end
    end

    context 'when the win condition is achieved by Player 1' do
      subject(:turn_move) { described_class.new(player1, player2, 0) }

      before do
        allow(player1).to receive(:player_moves)
        allow(player1).to receive(:add_move)
        allow(turn_move).to receive(:display)
        allow(turn_move).to receive(:prompt)
        allow(turn_move).to receive(:win?).and_return(true)
      end

      it 'displays a win message for Player 1' do
        win_message = "Player 1 wins!\nResetting game...\n\n\n"
        expect { turn_move.do_turn }.to output(win_message).to_stdout
      end

      it 'returns false to indicate the game is over' do
        return_value = turn_move.do_turn
        expect(return_value).to be false
      end
    end

    context 'when the win condition is achieved by Player 2' do
      subject(:turn_move) { described_class.new(player1, player2, 1) }

      before do
        allow(player2).to receive(:player_moves)
        allow(player2).to receive(:add_move)
        allow(turn_move).to receive(:display)
        allow(turn_move).to receive(:prompt)
        allow(turn_move).to receive(:win?).and_return(true)
      end

      it 'displays a win message for Player 2' do
        win_message = "Player 2 wins!\nResetting game...\n\n\n"
        expect { turn_move.do_turn }.to output(win_message).to_stdout
      end

      it 'returns false to indicate the game is over' do
        return_value = turn_move.do_turn
        expect(return_value).to be false
      end
    end

    context 'when the win condition is not achieved by Player 1' do
      subject(:turn_move) { described_class.new(player1, player2, 0) }

      before do
        allow(player1).to receive(:player_moves)
        allow(player1).to receive(:add_move)
        allow(turn_move).to receive(:display)
        allow(turn_move).to receive(:prompt)
        allow(turn_move).to receive(:win?).and_return(false)
      end

      it 'returns the new turn number to indicate the game is not over' do
        return_value = turn_move.do_turn
        expect(return_value).to be(1)
      end
    end
  end

  describe '#prompt' do
    # Located inside do_turn (Public Script Method)

    # Outgoing command
    # Looping script method

    context 'when the player enters an input' do
      subject(:prompt_move) { described_class.new(player1, player2) }

      before do
        allow($stdin).to receive(:gets).and_return('C1')
      end

      it 'sends the input to be validated by #validate_input' do
        expect(prompt_move).to receive(:validate_input)
        prompt_move.prompt
      end
    end
  end
end
