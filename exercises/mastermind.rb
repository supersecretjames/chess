require 'debugger'
module Mastermind
  PEGS = [:R, :G, :B, :Y, :O, :P]

  class Game
    attr_accessor :hidden_row
    def initialize
      @hidden_row = []
      @board = []
      @game_over = false
      @win = false
      @num_moves = 0
    end

    def run
      @human = HumanPlayer.new(self)
      @computer = ComputerPlayer.new(self)
      @hidden_row = @computer.pick_hidden_colors
      until @game_over
        @board.each { |line| p line}
        current_guess = @human.get_move
        @board << current_guess
        compare_guess(current_guess)
      end
      puts "Game over..."
      puts (@win ? "you won!" : "you lost :(")

    end

    def compare_guess(guess)
      #debugger
      if guess == @hidden_row
        @win, @game_over = true, true
        return
      end
      return @game_over = true if @num_moves == 10

      exact_match_num = 0
      4.times do |i|
        if guess[i] == @hidden_row[i]
          exact_match_num += 1
        end
      end

      fuzzy_match_num = 0
      hidden_row_copy = @hidden_row.dup
      guess.each do |guess_item|
        if hidden_row_copy.include?(guess_item)
          fuzzy_match_num += 1
          hidden_row_copy.delete_at(hidden_row_copy.index(guess_item))
        end
      end

      fuzzy_match_num = fuzzy_match_num - exact_match_num
      @num_moves += 1
      puts "You have #{exact_match_num} exact matches"
      puts "You have #{fuzzy_match_num} partial matches"
    end

  end

  class ComputerPlayer

    def initialize(current_game)
      @current_game = current_game
    end

    def pick_hidden_colors
      row = []
      4.times { row << PEGS.sample }
      row
    end

  end

  class HumanPlayer
    def initialize(current_game)
      @current_game = current_game
    end

    def get_move
      guess = false
      while guess == false
        puts "Make a guess? Choose four of these #{PEGS}"
        guess = verify_guess(gets.chomp)
      end
      guess
    end

    def verify_guess(guess)
      if guess == "d"
        p @current_game.hidden_row
        return false
      end
      guess_array = guess.split("").map {|g| g.to_sym}
      verified_guess = guess_array.select do |guess|
        PEGS.include?(guess)
      end
      verified_guess.length == 4 ? verified_guess : false
    end
  end
end

  m = Mastermind::Game.new
  m.run