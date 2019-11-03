require_relative "tic_tac_toe"

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
  end

  def winning_node?(evaluator)
  end

  # Generates an array of all moves that can be made after
  # the current move.
  def children
    empty_fields = []
    next_mover_mark = (@next_mover_mark == :x ? :o : :x)

    (0..2).each do |row|
      (0..2).each do |column|
        pos = [row, column]
        next unless @board.empty?(pos)

        if @board.empty?(pos)
          board = @board.dup
          board[pos] = @next_mover_mark
          empty_fields << TicTacToeNode.new(board, next_mover_mark, pos)
        end
      end
    end

    empty_fields
  end
end
