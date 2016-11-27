module Ace
  def value_of_ace(current_total)
    current_total > 10 ? 1 : 11
  end
end

class Participant
  attr_accessor :hand, :total
  def initialize
    @hand = []
  end
end

class Player < Participant
  include Ace

  def turn(other_hand)
    answer = nil
    loop do
      break if answer == 'stay' || bust?
      puts "hit or stay?"
      answer = gets.chomp
      if !(answer == 'hit' || answer == 'stay')
        puts "Enter a valid response"
        next
      end
      hit(other_hand) if answer == 'hit'
      information
    end
    not_hit
  end

  def not_hit
    if bust?
      puts "You busted. Dealer Wins!!!!!"
    else
      puts "You stayed"
    end
  end

  def bust?
    total > 21
  end

  def calculate_total
    @total = 0
    hand.each do |cards|
      @total += if cards[0] == 'Ace'
                  value_of_ace(total)
                else
                  Deck::VALUES[cards[0]]
                end
    end
    total
  end

  def information
    string = ""
    hand.each do |card|
      string += card[0] + " "
    end
    calculate_total
    puts "Player has #{string.split.join(' and ')}"
    puts "Your total is #{total}"
  end

  def hit(other_hand)
    card = []
    loop do
      card = [Deck::RANK.sample, Deck::SUITS.sample]
      while hand.include?(card) || other_hand.include?(card)
        card = [Deck::RANK.sample, Deck::SUITS.sample]
      end
      hand << card
      break
    end
  end
end

class Dealer < Participant
  include Ace

  def deal(player_hand, dealer_hand)
    2.times do |card|
      until player_hand[card] != dealer_hand[card]
        player_hand[card] = [Deck::RANK.sample, Deck::SUITS.sample]
        dealer_hand[card] = [Deck::RANK.sample, Deck::SUITS.sample]
      end
    end
  end

  def information
    str = ""
    hand.each do |card|
      str += card[0] + " "
    end
    arr = str.split
    arr.pop
    calculate_total
    puts "Dealer has #{arr.join(' and ')} and unknown"
  end

  def reveal_info
    string = ""
    hand.each do |card|
      string += card[0] + " "
    end
    puts "Dealer has #{string.split.join(' and ')}"
    puts "Dealer total is #{total}"
  end

  def calculate_total
    @total = 0
    hand.each do |cards|
      @total += if cards[0] == 'Ace'
                  value_of_ace(total)
                else
                  Deck::VALUES[cards[0]]
                end
    end
    total
  end

  def turn(other_hand)
    until total >= 17
      puts "Dealer hits"
      hit(other_hand)
      information
    end
    not_hit
  end

  def hit(other_hand)
    card = []
    loop do
      card = [Deck::RANK.sample, Deck::SUITS.sample]
      while hand.include?(card) || other_hand.include?(card)
        card = [Deck::RANK.sample, Deck::SUITS.sample]
      end
      hand << card
      break
    end
  end

  def not_hit
    if bust?
      puts "Dealer busted. You Win!!!"
    else
      puts "Dealer stayed"
    end
  end

  def bust?
    total > 21
  end
end

class Deck
  SUITS = %w(hearts diamonds clubs spades).freeze
  RANK = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace).freeze
  VALUES = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'Jack' => 10,
    'Queen' => 10,
    'King'  => 10
  }.freezes
end

class Game
  attr_reader :human, :dealer, :deck
  def initialize
    @human = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def display_welcome_message
    puts "Welcome, lets play 21 !!!!!"
    puts "---------------------------"
    puts "Now dealing cards ........."
  end

  def display_goodbye_message
    puts "Thank you for playing twenty one."
  end

  def show_cards
    human.information
    dealer.information
  end

  def reveal_cards
    human.information
    dealer.reveal_info
  end

  def show_result
    puts "Now comparing totals ............."
    reveal_cards
    if human.total > dealer.total
      puts "Player Wins !!!"
    elsif dealer.total > human.total
      puts "Dealer Wins !!!"
    else
      puts "Its a tie"
    end
  end

  def clear_screen_and_display
    system 'clear'
    puts "Player chose to stay"
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
    system 'clear'
  end

  def core_gameplay
    loop do
      dealer.deal(human.hand, dealer.hand)
      human.turn(dealer.hand)
      show_cards
      break if human.bust?
      clear_screen_and_display
      dealer.turn(human.hand)
      show_result unless dealer.bust?
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
