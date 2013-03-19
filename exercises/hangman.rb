require 'debugger'
class Hangman
  def initialize
  end

  def run
    @game_type = ask_for_game_type
    begin
      assign_roles
    rescue
      puts "Check your dictionary file!"
      return
    end
    @hangman_word = @picker.pick_word
    initialize_board
    @game_on = true

    while @game_on
      display_board
      guess = @guesser.guess(@board)
      confirmed = @picker.confirm(guess, @hangman_word)
      if !!confirmed
        fill_board(guess, confirmed)
        @game_on = false if board_full?
      end
      if @guesser.class == ComputerPlayer
        @guesser.condense_dictionary(guess, confirmed, @board)
      end
    end
    display_board
    puts "Congratulations, we won!"
  end

  def ask_for_game_type
    choices = {1 => :computer_picks_word, 2 => :human_picks_word}
    puts "Press 1 if you want to guess, 2 if you want the computer to guess"
    choices[gets.chomp.to_i]
  end

  def assign_roles
    if @game_type == :computer_picks_word
      @picker, @guesser = ComputerPlayer.new('hang_dic.txt'), HumanPlayer.new
    else
      @picker, @guesser = HumanPlayer.new, ComputerPlayer.new('hang_dct.txt')
    end
  end

  def initialize_board
    @board = ["_"] * @hangman_word.length
  end

  def display_board
    @board.each { |letter| print "#{letter} "}
    puts ""
  end

  def fill_board(guess, confirmed)
    if @picker.class == ComputerPlayer
      @hangman_word.length.times do |index|
        if @hangman_word[index] == guess
          @board[index] = guess
        end
      end
    else
      @board.length.times do |index|
        if confirmed.include?(index)
          @board[index] = guess
        end
      end
    end
  end

  def board_full?
    !@board.include?("_")
  end

end

class HumanPlayer

  def pick_word
    loop do
      puts "How many letters does your word have?"
      choice = gets.chomp.to_i
      if choice > 0
        return [" "] * choice
      end
    end
  end

  def guess(board)
    loop do
      puts "Guess a letter"
      guess = gets.chomp.downcase
      if guess.length == 1 && ('a'..'z').include?(guess)
        return guess
      end
    end
  end

  def confirm(guess, hangman_word)
    answer = ""
    loop do
      puts "Is this in the word? y/n"
      answer = gets.chomp.downcase
      break if answer == "y" || answer == "n"
    end
    if answer == "y"
      puts "What positions does it appear?  0-#{hangman_word.length - 1} i.e. '0 2 3'"
      correct_indices = gets.chomp.split(' ').map { |str| str.to_i }
    else
      false
    end
  end
end

class ComputerPlayer
  attr_accessor :dictionary

  def initialize(dict_file)
    @dictionary = []
    unless File.exists?(dict_file)
      raise "Dictionary '#{dict_file}' not found!"
    end
    File.foreach(dict_file) do |line|
      @dictionary << line.chomp.gsub('%', '')
    end
    @guesses = 0
    @unguessed_letters = ('a'..'z').to_a
  end

  def pick_word
    @dictionary.sample.split("")
  end

  def guess(board)
    if @guesses == 0
      @dictionary = @dictionary.select { |word| word.length == board.length}
      @guesses += 1
    end
    string_to_search = @dictionary.join
    best_letter = nil
    best_letter_count = 0
    @unguessed_letters.each do |letter|
      letter_count = string_to_search.count(letter)
      if letter_count > best_letter_count
        best_letter = letter
        best_letter_count = letter_count
      end
    end
    raise "There is no possible word!!!" if best_letter.nil?

    @unguessed_letters.delete(best_letter)
    puts "Computer guesses '#{best_letter}'"

    best_letter
  end

  def confirm(guess, hangman_word)
    hangman_word.include?(guess)
  end

  def condense_dictionary(guess, correct_guess, board)
    if not correct_guess
      @dictionary = @dictionary.select { |word| !word.include?(guess)}
    end
    @dictionary = @dictionary.select do |word|
      word_included = true
      word.length.times do |i|
        if word[i] != board[i] && board[i] != "_"
          word_included = false
        end
      end
      word_included
    end
  end

end

h = Hangman.new
h.run
