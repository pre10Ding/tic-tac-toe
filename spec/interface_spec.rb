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
    subject(:win_condition) { described_class.new(player1, player2, 0) }

    before(:each) do
      allow(player1).to receive(:add_move)
      allow(win_condition).to receive(:display)
      allow(win_condition).to receive(:prompt)
    end

    linear_winning_patterns = [%w[A1 B1 C1], %w[A3 B3 C3], %w[A1 A2 A3], %w[B1 B2 B3]]
    linear_winning_patterns.each do |pattern|
      context "when the line win pattern #{pattern.join('-')} is completed by Player 1" do

        it 'returns false to signal that the game should not continue' do
          allow(player1).to receive(:player_moves).and_return(pattern)
          expect(win_condition.do_turn).to be false
        end
      end
    end

    diagonal_winning_patterns = [%w[A1 B2 C3], %w[C1 B2 A3]]
    diagonal_winning_patterns.each do |pattern|
      context "when the diagonal win pattern #{pattern.join('-')} is completed by Player 1" do

        it 'returns false to signal that the game should not continue' do
          allow(player1).to receive(:player_moves).and_return(pattern)
          expect(win_condition.do_turn).to be false
        end
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

      it 'changes the turn counter by 1' do
        expect{ turn_move.do_turn }.to change { turn_move.instance_variable_get(:@turn) }.by(1)
      end
    end

    context 'when the player enters a valid input' do
      subject(:game_input) { described_class.new(player1, player2) }

      before do
        allow(game_input).to receive(:gets).and_return('C1')
        allow(player1).to receive(:player_moves).and_return(['A1', 'A2'])
        allow(player2).to receive(:player_moves).and_return(['B1', 'C2'])
        allow(game_input).to receive(:display)
        allow(game_input).to receive(:win?).and_return(false)

      end

      it 'the input is validated' do
        expect(player1).to receive(:add_move).with('C1').once
        game_input.do_turn
      end
    end

    context 'when the player enters a invalid input' do
      subject(:game_input) { described_class.new(player1, player2) }

      before do
        allow(game_input).to receive(:gets).and_return('H1', 'C1')
        allow(player1).to receive(:player_moves).and_return(['A1', 'A2'])
        allow(player2).to receive(:player_moves).and_return(['B1', 'C2'])
        allow(game_input).to receive(:display)
        allow(game_input).to receive(:win?).and_return(false)

      end

      it 'the input is validated' do
        expect(player1).not_to receive(:add_move).with('H1')
        expect(player1).to receive(:add_move).with('C1').once
        game_input.do_turn
      end
    end

    context 'when the player enters a input that was already made' do
      subject(:game_input) { described_class.new(player1, player2) }

      before do
        allow(game_input).to receive(:gets).and_return('A1', 'C1')
        allow(player1).to receive(:player_moves).and_return(['A1', 'A2'])
        allow(player2).to receive(:player_moves).and_return(['B1', 'C2'])
        allow(game_input).to receive(:display)
        allow(game_input).to receive(:win?).and_return(false)

      end

      it 'the input is validated' do
        expect(player1).not_to receive(:add_move).with('A1')
        expect(player1).to receive(:add_move).with('C1').once
        game_input.do_turn
      end
    end

  end
end
