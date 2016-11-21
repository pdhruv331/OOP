class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]] # diagonals

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " ".freeze
  attr_accessor :marker
  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :name

  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless (n =~ /[A-Za-z]/).nil?
      puts "Sorry, must enter a valid name"
    end
    @name = n
  end

  def set_marker
    answer = nil
    loop do
      puts "Hi #{@name} please pick X or O."
      answer = gets.chomp.downcase
      break if %(x o).include?(answer)
      puts "Thats not a valid choice."
    end
    @marker = answer.upcase
  end
end

class TTTGame
  FIRST_TO_MOVE = 'X'.freeze
  attr_reader :board, :human, :computer
  attr_accessor :human_score, :computer_score

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    @current_marker = FIRST_TO_MOVE
    @human_score = 0
    @computer_score = 0
  end

  def set_names
    human.set_name
    computer.name = %w(Jarvis Cortana Siri Vision).sample
  end

  def core_gameplay
    loop do
      display_score
      current_player_moves
      if board.someone_won? || board.full?
        clear_screen_and_display_board
        display_result
        continue_game?
        break
      end
      clear_screen_and_display_board
    end
  end

  def gameplay
    set_names
    set_markers
    loop do
      loop do
        board.reset
        display_board
        core_gameplay
        update_score
        display_result
        break if human_score == 5 || computer_score == 5
      end
      break unless play_again?
      reset
    end
  end

  def play
    display_welcome_message
    gameplay
    display_goodbye_message
  end

  private

  def set_markers
    human.set_marker
    computer.marker = if human.marker == 'X'
                        'O'
                      else
                        'X'
                      end
  end

  def continue_game?
    loop do
      puts "Press Enter to start next round"
      input = gets
      if input == "\n"
        return
      else
        puts "Thats not a valid input"
      end
    end
  end

  def update_score
    self.human_score += 1 if board.winning_marker == human.marker
    self.computer_score += 1 if board.winning_marker == computer.marker
  end

  def display_score
    puts "#{human.name} score: #{human_score}"
    puts "#{computer.name} score: #{computer_score}"
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thank you for playing Tic Tac Toe."
  end

  def clear
    system 'clear'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{human.marker}. #{computer.name} is a #{computer.marker}"
    puts ""
    board.draw
    puts ""
  end

  def joinor(arr, char1 = ', ', char = "or")
    if arr.size > 1
      last_element = arr.pop
      arr.insert(arr.length, "#{char} #{last_element}").join(char1)
    else
      arr.join
    end
  end

  def human_moves
    square = nil
    puts "Choose a square (#{joinor(board.unmarked_keys)})  "
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry thats not a valid choice"
    end
    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def display_result
    display_board
    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "Its a tie"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "#{human.name} would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
    puts "Lets play again!"
    puts ""
    self.human_score = 0
    self.computer_score = 0
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end
end

game = TTTGame.new
game.play
