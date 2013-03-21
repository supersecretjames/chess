module StraightMove
  def straight_move?(board, from, to, range_limit = 1)
    row_delta, col_delta = from[0] - to[0], from[1] - to[1]

    if row_delta == 0
      line_free?(board, from, to, range_limit, :horizontal)
    elsif col_delta == 0
      line_free?(board, from, to, range_limit, :vertical)
    else
      false
    end
  end

  protected
  # REV: (*) See **1**
  def line_free?(board, from, to, range_limit, line_type)
    var_idx = (line_type == :horizontal ? 1 : 0)  #index of variable field
    coords = from.dup
    return false if (from[var_idx] - to[var_idx]).abs > range_limit
    range_index = [from[var_idx], to[var_idx]]
    (range_index.min + 1...range_index.max).each do |dynamic_coord|
      coords[var_idx] = dynamic_coord
      return false if board[coords]
    end
    true
  end
end

module DiagonalMove
  # REV: (*) See **1**
  def diagonal_move?(board, from, to, range_limit = 1)
    row_delta, col_delta = from[0] - to[0], from[1] - to[1]
    return false unless is_diagonal?(row_delta, col_delta, range_limit)
    check = from.dup
    while true
      check[0] += (row_delta > 0 ? -1 : 1)
      check[1] += (col_delta > 0 ? -1 : 1)
      break if check == to
      return false if board[check]
    end
    true
  end

  def is_diagonal?(d_row, d_col, range_limit)
    d_row.abs == d_col.abs && d_row.abs <= range_limit && d_col <= range_limit
  end
end
