class Player
  attr_reader :name, :color
  def initialize(name)
    @name = name
  end
  def set_color(color)
    @color = color if @color.nil?
  end
end

class HumanPlayer < Player
  def initialize(name)
    super(name)
  end

  def make_move(board)
    print_board(board)
    print "#{board.check?(self) ? "Check! " : ""}"
    print "Your turn, #{name}! Please make a move (eg e2, e3): "
    gets.chomp.gsub(/[^A-Za-z0-9]/,' ').split(' ')
  end

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