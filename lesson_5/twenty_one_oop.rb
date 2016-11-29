class Card
  attr_reader :face
  SUITS = %w(hearts diamonds clubs spades).freeze
  FACES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace).freeze

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "The #{@face} of #{@suit}"
  end

  def ace?
    @face == 'Ace'
  end

  def royal?
    @face == 'Jack' || @face == 'Queen' || @face == 'King'
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        @cards << Card.new(suit, face)
      end
    end

    @cards.shuffle!
  end

  def deal
    cards.pop
  end
end

module Displayable
  def display_welcome_message
    puts "Welcome, lets play 21 !!!!!"
    puts "---------------------------"
    puts "Now dealing cards ........."
  end

  def display_goodbye_message
    puts "Thank you for playing twenty one."
  end

  def clear_screen_and_display
    sleep(1)
    system 'clear'
    puts "Player chose to stay"
    puts "Dealer's Turn........"
  end

  def show_totals
    puts "Player total: #{human.total}. Dealer total: #{dealer.total}"
  end
end

module Hand
  def hit(card)
    hand << card
  end

  def show_hand
    puts "#{name}'s hand: "
    hand.each do |card|
      puts card.to_s
    end
    puts "#{name}'s total: #{total}"
  end

  def total
    total = 0
    hand.each do |card|
      total += if card.ace?
                 11
               elsif card.royal?
                 10
               else
                 card.face.to_i
               end
    end

    hand.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def not_hit
    if bust?
      puts "#{name} busted. #{name} loses"
    else
      puts "#{name} stayed"
    end
  end

  def bust?
    total > 21
  end
end

class Participant
  include Hand
  attr_accessor :name, :hand

  def initialize
    @hand = []
    set_name
  end
end

class Player < Participant
  def set_name
    self.name = 'Player'
  end

  def choice
    answer = nil
    loop do
      break if bust?
      puts "hit or stay?"
      answer = gets.chomp
      if !(answer == 'hit' || answer == 'stay')
        puts "Enter a valid response"
        next
      end
      break
    end
    answer
  end
end

class Dealer < Participant
  def set_name
    self.name = 'Dealer'
  end

  def show_hidden_hand
    puts "#{name} has: "
    puts "#{hand.first} and unknown"
  end
end

class Game
  include Displayable
  attr_accessor :human, :dealer, :deck
  def initialize
    @human = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def deal_initial_cards
    2.times do
      human.hit(deck.deal)
      dealer.hit(deck.deal)
    end
  end

  def show_cards
    human.show_hand
    dealer.show_hidden_hand
  end

  def human_turn
    puts "Player's Turn........"
    loop do
      break if human.choice == 'stay' || human.bust?
      human.hit(deck.deal)
      human.show_hand
    end

    human.not_hit
  end

  def dealer_turn
    until dealer.total >= 17
      puts "Dealer hits"
      dealer.hit(deck.deal)
      dealer.show_hand
      sleep(2)
      system 'clear'
    end
    dealer.not_hit
  end

  def player_turns
    human_turn
    return if human.bust?
    clear_screen_and_display
    dealer_turn
  end

  def show_result
    puts "Now comparing totals ............."
    show_totals
    if human.total > dealer.total
      puts "Player Wins !!!"
    elsif dealer.total > human.total
      puts "Dealer Wins !!!"
    else
      puts "Its a tie"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry must be y or n"
    end
    answer == 'y'
  end

  def reset
    human.hand.clear
    dealer.hand.clear
    self.deck = Deck.new
    system 'clear'
  end

  def core_gameplay
    loop do
      deal_initial_cards
      show_cards
      player_turns
      show_result unless human.bust? || dealer.bust?
      break
    end
  end

  def gameplay
    loop do
      core_gameplay
      break unless play_again?
      reset
    end
  end

  def play
    display_welcome_message
    gameplay
    display_goodbye_message
  end
end

Game.new.play
