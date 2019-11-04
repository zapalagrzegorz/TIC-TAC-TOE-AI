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
      return false if @board.winner == evaluator || @board.winner.nil?

      return true
    end

    if next_mover_mark == evaluator
      children.all? { |node| node.losing_node?(evaluator) }
    else
      children.any? { |node| node.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    return @board.winner == evaluator if @board.over?

    winning_node = Proc.new { |node| node.winning_node?(evaluator) }

    if next_mover_mark == evaluator
      children.any?(&winning_node)
    else
      children.all?(&winning_node)
    end
  end

  # Generates an array of all moves that can be made after
  # the current move.
  def children
    empty_fields = []

    (0..2).each do |row|
      (0..2).each do |column|
        pos = [row, column]
        next unless @board.empty?(pos)

        board = @board.dup
        board[pos] = @next_mover_mark
        next_mover_mark = (@next_mover_mark == :x ? :o : :x)
        empty_fields << TicTacToeNode.new(board, next_mover_mark, pos)
      end
    end

    empty_fields
  end
end
