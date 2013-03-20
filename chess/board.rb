# encoding: utf-8
require 'colorize'

class Board
  def initialize(rows = nil)
    @rows = rows.nil? ? Board.starting_grid : rows
  end

  # REV: This is nice. The self.royals helper reads well.
  def self.starting_grid
    [
      Board.royals(:black),
      [Pawn.new(:black)] * 8,
      [nil] * 8,
      [nil] * 8,
      [nil] * 8,
      [nil] * 8,
      [nil] * 8,#[Pawn.new(:white)] * 8,
      Board.royals(:white)
    ]
  end

  def self.royals(color)
    [
      Rook.new(color),
      Knight.new(color),
      Bishop.new(color),
      Queen.new(color),
      King.new(color),
      Bishop.new(color),
      Knight.new(color),
      Rook.new(color)
    ]
  end

  # REV: Add comment with what "rc" stands for.
  def self.chess_to_rc_notation(chess)
    row = 8 - chess[1].to_i
    col = chess[0].ord - 'a'.ord
    return row, col
  end

  def self.rc_to_chess_notation(row, col)

  end

  # REV: **4** (See **3** for complimentary comment.)
  # player looks like it's only being used for the color, but you can get this
  # from the piece at the "from" location of the board.
  # Not sure which is better... one way seems to let you pass one less
  # argument, but having player.color in the code reads nicely.
  def valid_move?(player, from, to)
    if Board.on_board?(from) && Board.on_board?(to) && from != to && self[from]
      piece = self[from]
      return false unless piece.color == player.color
      if piece.valid_move?(self.dup, from, to)
        return false if move_results_in_self_check?(player, from, to)
        self[to].nil? || (self[to].color != player.color)
      end
    else
      false
    end
  end

  def move_results_in_self_check?(player, from, to)
    check_board = self.dup
    check_board.pretty_print
    check_board.commit_move(from, to)
    check_board.check?(player)
  end

  def []=(coord, value)
    @rows[coord[0]][coord[1]] = value
  end

  def [](coord)
    @rows[coord[0]][coord[1]]
  end

  def self.on_board?(coords)
    coords.all? { |coord| coord.between?(0,7) }
  end

  # REV: This method is very nice and easy to read.
  def move(player, from, to)
    if valid_move?(player, from, to)
      commit_move(from, to)
    else
      raise "invalid move"
    end
  end

  # REV: This method reads well too.
  def check?(player)
    king_coord = king_location(player)
    @rows.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || (piece.color == player.color)
        return true if piece.valid_move?(self, [i, j], king_coord)
      end
    end
    false
  end

  def king_location(player)
    @rows.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil?
        # REV: Very nice line here with the king search.
        return [i, j] if (piece.color == player.color) && (piece.is_a?(King))
      end
    end

  end

  def checkmate?(checked_player)
    return false    #checkmate not working yet
    return false unless check?(checked_player)
    @rows.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || (piece.color != checked_player.color)
        from = [i, j]
        possible_moves = piece.possible_moves(self.dup, checked_player, from)
        possible_moves.each do |possible_move|
          next if self[possible_move].is_a?(King)
          copy = self.dup
          copy.commit_move(from, possible_move)
          return false unless copy.check?(checked_player)
        end
      end
    end
    true
  end

=begin
  def winner
    return checkmate_color
  end
=end

  def draw?
    false #TODO
  end

  def dup
    Board.new(@rows.map(&:dup))
  end

  def pretty_print
    top = "   #{("a".."h").to_a.join('  ')}\n"
    row_index = 8
    background = [:black, :white]
    char_arr = @rows.map do |row|
      left = "#{row_index} "
      char_row = row.map do |piece|
        s = case piece
        # REV: This looks nice, but it might be better to just have the
        # unicode chars.
        when King then piece.color == :white ? " ♔ " : " ♚ "
        when Queen then piece.color == :white ? " ♕ " : " ♛ "
        when Rook then piece.color == :white ? " ♖ " : " ♜ "
        when Bishop then piece.color == :white ? " ♗ " : " ♝ "
        when Knight then piece.color == :white ? " ♘ " : " ♞ "
        when Pawn then piece.color == :white ?  " ♙ " : " ♟ "
        else
          "   "
        end
        # REV: Sounds like you're inverting colors here:
        background.reverse!
        s.colorize(:color => background.last, :background => background.first)
      end
      row_index -= 1
      background.reverse!
      left + char_row.join('')
    end
    top + char_arr.join("\n")
  end

  protected
  def commit_move(from, to)
    #set_at(to, get_at(from))
    self[to] = self[from]
    self[from] = nil
  end
end
