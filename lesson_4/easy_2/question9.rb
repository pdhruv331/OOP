class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    "Lets play Bingo!"
  end
end

# The play method in Bingo overrides the play method in Game. 
# If an instance of class bingo were to call the play method. The play method in the bingo class would be accessed.