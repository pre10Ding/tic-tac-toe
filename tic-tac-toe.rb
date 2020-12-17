
require 'pry'
#tic-tac-toe specific behaviors for player/AI
module TicTacToe 
  
  private
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
    end

    #check triple occurences (verticle and horizontal winning patterns)
    moves_tallied = player_moves.flatten.join.chars.tally

    if moves_tallied.values.any?(3) || pattern_matched
      return 1
    end

  end

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

#Tracks moves that the player has made
class Player
  def initialize (player_number)
    @player_number = player_number
    @player_moves = []
  end
  attr_reader :player_moves
  def add_move(move)
    @player_moves << move
  end  

end

#Tracks turns and gets user input
class Interface
  
  include TicTacToe

  def initialize(player1,player2)
    @players = [player1,player2]
    @turn = 0
    self.display(@players)
  end

  def do_turn
    @players[ (@turn % 2) ].add_move(self.prompt)
    self.display(@players)
    if self.win?(@players[ (@turn % 2) ].player_moves) #check if game end
      puts "Player #{@turn % 2 + 1} wins!"
      puts "Resetting game...\n\n\n"
      return false
    end
    @turn += 1
    return @turn
  end

  private

  def prompt #asks user for input and returns the move

    while(true) #validation loop
      puts "Player #{@turn % 2 + 1}, please enter your move. (ie. \"C1\")"
      player_input = gets.chomp
      break if self.validate_input(@players,player_input)
      puts "Invalid input!"
    end

    player_input
  end


end



player1 = Player.new(0)
player2 = Player.new(1)
ui = Interface.new(player1,player2)

while(true) do #call ui method 
  unless ui.do_turn #if do_turn returns false, game needs to be reset
    player1 = Player.new(0)
    player2 = Player.new(1)
    ui = Interface.new(player1,player2)
  end
end


