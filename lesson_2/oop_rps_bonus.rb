class Move
  attr_reader :value, :player_history, :computer_history
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze
  R2_Values = ['rock'].freeze
  Hal_VALUES = ['scissors', 'scissors', 'scissors', 'scissors', 'rock'].freeze
  Chappie_VALUES = ['lizard', 'spock'].freeze
  Sonnie_VALUES = ['paper', 'paper', 'paper', 'paper', 'lizard', 'lizard',
                   'spock', 'scissors', 'scissors', 'scissors'].freeze

  WIN_SCENARIO = {
    'rock' => %w(scissors lizard),
    'paper' => %w(rock spock),
    'scissors' => %w(paper lizard),
    'spock' => %w(scissors rock),
    'lizard' => %w(spock paper)
  }.freeze

  LOOSE_SCENARIO = {
    'rock'     => %w(paper spock),
    'paper'    => %w(scissors lizard),
    'scissors' => %w(rock spock),
    'spock'    => %w(paper lizard),
    'lizard'   => %w(rock scissors)
  }.freeze

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WIN_SCENARIO[value].include?(other_move.value)
  end

  def <(other_move)
    LOOSE_SCENARIO[value].include?(other_move.value)
  end

  def to_s
    value
  end
end

class History
  attr_accessor :player_history, :computer_history
  def initialize
    @computer_history = []
    @player_history = []
  end

  def update(human_move, computer_move)
    player_history << human_move.value
    computer_history << computer_move.value
  end

  def display
    puts "Player history: #{player_history}"
    puts "Computer history: #{computer_history}"
  end

  def clear
    @computer_history = []
    @player_history = []
  end
end

class Player
  attr_accessor :move, :name
  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock: "
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonnie', 'Number 5'].sample
  end

  def r2d2
    # R2D2 always chooses Rock
    self.move = Move.new(Move::R2_VALUES.sample)
  end

  def hal
    # Chooses Scissors almost always. Never chooses paper
    self.move = Move.new(Move::Hal_VALUES.sample)
  end

  def chappie
    # Only pick lizard or spock
    self.move = Move.new(Move::Chappie_VALUES.sample)
  end

  def sonnie
    # 40% Paper, 30% Scissors, 20% lizard, 10% spock, no rock
    self.move = Move.new(Move::Sonnie_VALUES.sample)
  end

  def number5
    # No particular trait
    self.move = Move.new(Move::VALUES.sample)
  end

  def choose
    case name
    when 'R2D2' then r2d2
    when 'Hal' then hal
    when 'Chappie' then chappie
    when 'Sonnie' then sonnie
    when 'Number 5' then number5
    end
  end
end

class RPSGame
  attr_accessor :human, :computer, :human_score, :computer_score, :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @history = History.new
    @human_score = 0
    @computer_score = 0
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thank you for playing Rock, Paper, Scissors. Good Bye!"
  end

  def display_move
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "Its a tie!"
    end
  end

  def display_score
    puts "#{human.name} score: #{human_score}"
    puts "#{computer.name} score: #{computer_score}"
  end

  def update_history
    history.update(human.move, computer.move)
  end

  def display_history
    history.display
  end

  def update_score
    self.human_score += 1 if human.move > computer.move
    self.computer_score += 1 if human.move < computer.move
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end
    return false if answer == 'n'
    return true if answer == 'y'
  end

  def reset
    self.human_score = 0
    self.computer_score = 0
    history.clear
  end

  def players_pick
    human.choose
    computer.choose
  end

  def game_loop
    loop do
      reset
      loop do
        break if self.human_score == 5 || self.computer_score == 5
        players_pick
        update_score
        update_history
        display_move
        display_winner
        display_score
      end
      display_history
      break unless play_again?
    end
  end

  def play
    display_welcome_message
    game_loop
    display_goodbye_message
  end
end

RPSGame.new.play
