require "./tictactoe.rb" 
require "./interface.rb"
require "./player.rb"

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
