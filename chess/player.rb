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

  def invalid_move(from, to)
    s = "That move was invalid. Cannot move from #{from} to #{to}!"
    puts s.colorize(:color => :red)
  end
end

class HumanPlayer < Player
  def make_move(board)
    print_board(board)
    print "#{board.check?(self.color) ? "Check! " : ""}"
    print "Your turn, #{name}! Please make a move (eg e2, e3): "
    # REV: Instead of changing all non-alphanumeric characters to spaces and
    # then splitting on spaces, you can just pass in a regex for such a match
    # directly into split.
    # gets.chomp.split(/[^A-Za-z0-9]+/)
    gets.chomp.gsub(/[^A-Za-z0-9]/,' ').split(' ')
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
    return Board.coord_to_chess(from), Board.coord_to_chess(to)
  end
end