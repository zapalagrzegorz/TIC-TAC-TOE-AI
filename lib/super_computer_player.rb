require_relative "tic_tac_toe_node"
require "byebug"

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    minimax = TicTacToeNode.new(game.board, mark)
    child_nodes = minimax.children

    winning_node = child_nodes.find do |node|
      node if node.winning_node?(mark)
    end

    return winning_node.prev_move_pos unless winning_node.nil?

    non_losing_node = minimax.children.find do |node|
      node unless node.losing_node?(mark)
    end

    return non_losing_node.prev_move_pos if non_losing_node

    raise IllegalMoveError
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
