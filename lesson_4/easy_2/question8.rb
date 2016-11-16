class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

# By adding < Game to the Bingo class we make the Bingo class a subclass of Game. This allows it to inherit its methods