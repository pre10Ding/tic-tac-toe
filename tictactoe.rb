# frozen_string_literal: true

# tic-tac-toe specific behaviors for player/AI
module TicTacToe
  private

  def display(players)
    game_board_state = {}
    game_symbols = ["X","O"]
    3.times do |i|
      3.times do |j|
        game_board_state["#{(i+65).chr}#{j+1}"] = 0
      end
    end
    players.each_with_index do |player, index|
      player.player_moves.each {|move| game_board_state[move] = game_symbols[index]}
    end
    game_board_with_ascii = "\nA-_|_|_\nB-_|_|_\nC- | | "
    game_tile_index = 0
    game_board_with_ascii = game_board_with_ascii.chars.map do |character|
      if character == " " || character == "_"
        current_tile = game_board_state[game_board_state.keys[game_tile_index]]
        character = current_tile unless current_tile == 0
        game_tile_index += 1
      end
      character
    end
    puts "  1 2 3" + game_board_with_ascii.join

  end
  
  VALID_INPUTS = %w[A1 A2 A3 B1 B2 B3 C1 C2 C3]
  #other winning pattern would be just 3 of the same letter/number
  DIAGONAL_WINNING_PATTERNS = [%w[A1 B2 C3],%w[C1 B2 A3]]
  def win?(player_moves) #return 1 if the new move won the game, return 0 otherwise
    #winning check logic
    #check diagonal winning patterns
    pattern_matched = false
    DIAGONAL_WINNING_PATTERNS.each do |pattern|
      pattern_matched = true
      pattern.each do |move|
        unless player_moves.include?(move)
          pattern_matched = false
          break
        end
      end
      break if pattern_matched
    end

    #check triple occurences (verticle and horizontal winning patterns)
    moves_tallied = player_moves.flatten.join.chars.tally

    1 if moves_tallied.values.any?(3) || pattern_matched
  end

  def validate_input(players,input) 
    #first check if the input is a part of the game
    return false unless VALID_INPUTS.include?(input)
    #now check if the move has already been made by players
    players.each do |player|
      return false if player.player_moves.include?(input)
    end
    return true
  end

end