# encoding: utf-8
require 'colorize'

class Board
  def initialize(rows = nil)
    @rows = rows.nil? ? Board.starting_grid : rows
  end

  def self.starting_grid
    [
      Board.royals(:black),
      [Pawn.new(:black)] * 8,
      [nil] * 8,
      [nil] * 8,
      [nil] * 8,
      [nil] * 8,
      [Pawn.new(:white)] * 8,
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

  def self.chess_to_rc_notation(chess)
    row = 8 - chess[1].to_i
    col = chess[0].ord - 'a'.ord
    return row, col
  end

  def self.rc_to_chess_notation(row, col)

  end

  def valid_from?(player_color, from)
    Board.on_board?(from) && self[from] && self[from].color == player_color
  end

  def valid_to?(player_color, to)
    Board.on_board?(to) && (self[to].nil? || self[to].color != player_color)
  end

  def valid_move?(color, from, to)
    if valid_from?(color, from) && valid_to?(color, to) && from != to
      piece = self[from]
      piece.valid_move?(self, from, to) && ! move_into_check?(color, from, to)
    else
      false
    end

=begin
    if Board.on_board?(from) && Board.on_board?(to) && from != to && self[from]
      piece = self[from]
      return false unless piece.color == player_color
      if (self[to].nil? || self[to].color != player_color) &&
        piece.valid_move?(self.dup, from, to) &&
        !move_results_in_self_check?(player_color, from, to)
        true
      else
        false
      end
    else
      false
    end
=end
  end

  def move_into_check?(player_color, from, to)
    check_board = self.dup
    check_board.pretty_print
    check_board.commit_move(from, to)
    check_board.check?(player_color)
  end

  def [](coord)
    @rows[coord[0]][coord[1]]
  end

  def self.on_board?(coords)
    coords.all? { |coord| coord.between?(0,7) }
  end

  def move(player_color, from, to)  #valid move should be checked before this!
    if valid_move?(player_color, from, to)
      commit_move(from, to)
    else
      raise "InvalidMoveError"  #if called properly, this never happens
    end
  end

  def check?(player_color)
    king_coord = king_location(player_color)

    self.each_piece_with_index do |piece, i, j|
      next if piece.color == player_color
      return true if piece.valid_move?(self, [i, j], king_coord)
    end
    false
  end

  def king_location(player_color)
    self.each_piece_with_index do |piece, i, j|
      return [i, j] if (piece.color == player_color) && (piece.is_a?(King))
    end
    raise "KingNotFoundError"
  end

  def checkmate?(checked_player_color)  # doesn't work!
    all_possible_moves(checked_player_color).each do |from, possible_moves|
      possible_moves.each do |possible_move|
        copy = self.dup
        copy.commit_move(from, possible_move)
        return false unless copy.check?(checked_player_color)
      end
    end
    true
  end

  def all_possible_moves(color)
    all_possible_moves = {}
    self.each_piece_with_index do |piece, i, j|
      next unless piece.color == color
      from = [i, j]
      all_possible_moves[from] = piece.possible_moves(self.dup, color, from)
    end
    all_possible_moves
  end

  def each_piece_with_index(&proc)
    (0...8).each do |i|
      (0...8).each do |j|
        next if self[[i,j]].nil?
        proc.call(self[[i,j]], i, j)
      end
    end
  end

  def draw?
    false #TODO
  end

  def dup
    Board.new(@rows.dup.map(&:dup))
  end

  def pretty_print
    top = "   #{("a".."h").to_a.join('  ')}\n"
    row_index = 8
    background = [:red, :white]
    char_arr = @rows.map do |row|
      left = "#{row_index} "
      char_row = row.map do |piece|
        s = case piece
        when King then " ♚ "
        when Queen then " ♛ "
        when Rook then " ♜ "
        when Bishop then " ♝ "
        when Knight then " ♞ "
        when Pawn then " ♟ "
        else
          "   "
        end
        color = :white
        unless piece.nil?
          piece.color == :white ? color = :light_white : color = :black
        end
        background.reverse!
        s.colorize(:color => color, :background => background.first)
      end
      row_index -= 1
      background.reverse!
      left + char_row.join('')
    end
    top + char_arr.join("\n")
  end

  protected
  def commit_move(from, to)
    self[to] = self[from]
    self[from] = nil
  end

  def []=(coord, value)
    @rows[coord[0]][coord[1]] = value
  end
end
