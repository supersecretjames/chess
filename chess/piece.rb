require './move_modules'

class Piece
  attr_reader :color
  def initialize(color)
    @color = color
  end

  def possible_moves(board, player, from)
    possible_moves = []
    (0...8).each do |i|
      (0...8).each do |j|
        possible_moves << [i, j] if board.valid_move?(player, from, [i ,j])
      end
    end
    possible_moves
  end
end

class Pawn < Piece
  def valid_move?(board, from, to)
    row_delta = @color == :white ? 1 : -1
    if from[0] - to[0] == row_delta
      if from[1] == to[1]
        board[to].nil?
      else (from[1] - to[1]).abs == 1
        board[to] && board[to].color != @color
      end
    else
      false
    end
  end
end

class Rook < Piece
  include StraightMove
  def valid_move?(board, from, to)
    straight_move?(board, from, to, 7)
  end
end

class Bishop < Piece
  include DiagonalMove
  def valid_move?(board, from, to)
    diagonal_move?(board, from, to, 7)
  end
end

class Queen < Piece
  include DiagonalMove, StraightMove
  def valid_move?(board, from, to)
    straight_move?(board, from, to, 7) || diagonal_move?(board, from, to, 7)
  end
end

class Knight < Piece
  MOVE_OFFSETS = [[-2, -1], [-2,  1], [-1, -2], [-1,  2],
                  [ 1, -2], [ 1,  2], [ 2, -1], [ 2,  1]]

  def valid_move?(board, from, to)
    valid_moves(from).include?(to)
  end

  protected
  def valid_moves(start_pos)
    valid_moves = []
    cur_x, cur_y = start_pos

    MOVE_OFFSETS.each do |(dx, dy)|
      new_pos = [cur_x + dx, cur_y + dy]
      valid_moves << new_pos if Board.on_board?(new_pos)
    end

    valid_moves
  end
end

class King < Piece
  include DiagonalMove, StraightMove
  def valid_move?(board, from, to)
    straight_move?(board, from, to, 1) || diagonal_move?(board, from, to, 1)
  end
end
