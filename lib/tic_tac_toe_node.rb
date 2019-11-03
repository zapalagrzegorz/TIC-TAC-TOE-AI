require_relative "tic_tac_toe"

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    # base case
    if @board.over?
      if @board.winner == evaluator || @board.tied?
        return false
      else
        return true
      end
    end

    # recursive case
    #  It is the player's turn, and all the children nodes are losers for the player
    #  (anywhere they move they still lose), OR
    # It is the opponent's turn, and one of the children nodes is a losing node
    # for the player (assumes your opponent plays perfectly; they'll force you to lose if they can).

    #  when it's the player's turn
    losing_node = Proc.new { |node| node.losing_node?(evaluator) }

    if evaluator == :o
      children.all?(&losing_node)
    else
      children.any?(&losing_node)
    end
  end

  def winning_node?(evaluator)
    if @board.over?
      if @board.winner == evaluator || @board.tied?
        return true
      else
        return false
      end
    end

    winning_node = Proc.new { |node| node.winning_node?(evaluator) }

    if evaluator == :x
      children.any?(&winning_node)
    else
      children.all?(&winning_node)
    end
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
