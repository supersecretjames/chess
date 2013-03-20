class Player
  attr_reader :name, :color
  def initialize(name)
    @name = name
  end
  def set_color(color)
    @color = color if @color.nil?
  end

  def end_game(board)
    print_board(board)
    puts "Checkmate! #{name} wins!"
  end

  def print_board(board)
    puts board.pretty_print
  end
end

class HumanPlayer < Player
  def make_move(board)
    print_board(board)
    print "#{board.check?(self.color) ? "Check! " : ""}"
    print "Your turn, #{name}! Please make a move (eg e2, e3): "
    gets.chomp.gsub(/[^A-Za-z0-9]/,' ').split(' ')
  end

  def invalid_move(from, to)
    s = "That move was invalid. Cannot move from #{from} to #{to}!"
    puts s.colorize(:color => :red)
  end
end

class ComputerPlayer < Player
  def initialize
    super("Computer")
  end

  def make_move(board)
    all_possible_moves = board.all_possible_moves(self.color)
    from = all_possible_moves.keys.sample
    to = all_possible_moves[from].sample

  end

  def invalid_move
  end

  def print_board(board)
  end

  def end_game(board)
  end

end