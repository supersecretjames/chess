

require './board'
require './player'
require './piece'

class Chess #Game class

  def self.play(player1, player2)
    board = Board.new
    # REV: **2** (See **1** in player.rb for complimentary comment.)
    # From the external usage of "set_color", it looks like we could use it to
    # swap player colors. This would be useful if the players were to play
    # multiple games and wanted to switch colors each game.
    player1.set_color(:white)
    player2.set_color(:black)
    turns = [player1, player2]

    while true
      # REV: Bonus extension for fun: keep track of move history and maybe
      # make an array of moves in chess notation like [[Qe4, Qe5], ...].
      # Then you could get which player's turn by the length of this array:
      # player = moves.length.even? player1 : player2
      player = turns.first
      from, to = player.make_move(board.dup)
      # REV: What does "rc" mean? Perhaps add a comment, or expand it?
      from_coord = Board.chess_to_rc_notation(from)
      to_coord = Board.chess_to_rc_notation(to)
      # REV: **3** (See **4** for complimentary comment.)
      # Do you need to pass player?
      if board.valid_move?(player, from_coord, to_coord)
        board.move(player, from_coord, to_coord)
        # REV: How bout making a helper method to make the intent clearer?
        # toggle_player(turns)
        # def toggle_player(turns)
        #   turns.reverse!
        # end
        turns.reverse!
        if board.checkmate?(turns.first)
          puts "checkmate!"
        end
        break if board.checkmate?(turns.first)  #not checking for draws
      else
        player.invalid_move
      end
    end
  end
end


Chess.play(HumanPlayer.new("James"), HumanPlayer.new("Peter"))