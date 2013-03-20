# REV: It's a bit hard to follow what each module is doing.

module StraightMove
  def straight_move?(board, from, to, range_limit = 1)
    row_delta, col_delta = from[0] - to[0], from[1] - to[1]

    if row_delta == 0
      check_line_free(board, from, to, range_limit, from[0], 1)
    elsif col_delta == 0
      check_line_free(board, from, to, range_limit, from[1], 0)
    else
      false
    end
  end

  protected
  # REV: Rename to line_free? since it returns true or false.
  # REV: dynamic_index and dynamic_coord are a bit vague.
  def check_line_free(board, from, to, range_limit, fixed, dynamic_index)
    return false if (from[dynamic_index] - to[dynamic_index]).abs > range_limit

    # REV: This line is 148 chars, almost double the max width of 80.
    range = from[dynamic_index] > to[dynamic_index] ? (to[dynamic_index] + 1...from[dynamic_index]) : (from[dynamic_index] + 1...to[dynamic_index])
    range.each do |dynamic_coord|
      coords = []
      coords[dynamic_index] = dynamic_coord
      coords[1 - dynamic_index] = fixed
      return false if board[coords]
    end

    true
  end
end

module DiagonalMove
  def diagonal_move?(board, from, to, range_limit = 1)
    row_delta, col_delta = from[0] - to[0], from[1] - to[1]

    if row_delta.abs != col_delta.abs ||
      row_delta.abs > range_limit || col_delta > range_limit
      return false
    end

    check = from.dup

    while true
      check[0] += row_delta > 0 ? -1 : 1
      check[1] += col_delta > 0 ? -1 : 1
      break if check == to
      return false if board[check]
    end

    true
  end
end
