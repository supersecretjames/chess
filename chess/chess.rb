require './board'
require './player'
require './piece'

class Chess #Game class
  def self.play(player1, player2)
    board = Board.new
    player1.set_color(:white)
    player2.set_color(:black)
    turns = [player1, player2]
    while true
      player = turns.first
      from, to = player.make_move(board.dup)
      from_coord = Board.chess_to_rc_notation(from)
      to_coord = Board.chess_to_rc_notation(to)
      if board.valid_move?(player.color, from_coord, to_coord)
        board.move(player.color, from_coord, to_coord)
        turns.reverse!

        if board.checkmate?(turns.first.color) || board.draw?
          player.end_game(board)
          break
        end
      else
        player.invalid_move
      end
    end
  end
end

Chess.play(HumanPlayer.new("James"), HumanPlayer.new("Peter"))