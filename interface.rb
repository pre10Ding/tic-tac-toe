require "./tictactoe.rb" 
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
