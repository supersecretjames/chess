class Player
  attr_reader :name, :color

  def initialize(name)
    @name = name
  end

  # REV: **1** (See **2** in chess.rb for complementary comment.)
  # "set_color" method name gives no indication that it can not actually set
  # the color more than once.
  def set_color(color)
    @color = color if @color.nil?
  end
end

class HumanPlayer < Player

  # REV: No need to rewrite initialize here if it does nothing different.
  def initialize(name)
    super(name)
  end

  def make_move(board)
    print_board(board)
    print "#{board.check?(self) ? "Check! " : ""}"
    print "Your turn, #{name}! Please make a move (eg e2, e3): "
    gets.chomp.gsub(/[^A-Za-z0-9]/,' ').split(' ')
  end

  # REV: make method name a verb since it's used for its side effect.
  def invalid_move
    puts "That move was invalid."
  end

  def print_board(board)
    puts board.pretty_print
  end
end

class ComputerPlayer < Player
  #TODO!
end