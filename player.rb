# Tracks moves that the player has made
class Player
  def initialize(player_number)
    @player_number = player_number
    @player_moves = player_moves
  end
  attr_reader :player_moves

  def add_move(move)
    @player_moves << move
  end
end
