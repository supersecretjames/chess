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
      from_pos, to_pos = Board.chess_to_coord(from), Board.chess_to_coord(to)
      if board.try_move?(player.color, from_pos, to_pos)
        turns.reverse!
        # REV: This single blank line in the middle of all these lines looks
        # a bit awkward. 

        if board.checkmate?(turns.first.color) || board.draw?
          player.end_game(board)
          break
        end
      else
        player.invalid_move(from, to)
      end
    end
  end
end

Chess.play(HumanPlayer.new("James"), ComputerPlayer.new)