require 'colorize'

class Piece
  attr_reader :king
  alias_method :king?, :king
  
  NORTH, SOUTH = [[-1, -1], [-1, 1]], [[1, 1], [1, -1]]
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @directions = directions
    @king = false
  end
  
  def can_jump_to?(dir) 
    opponent_pos = Board.adj_pos(@pos, dir)
    jump_pos = Board.adj_pos(opponent_pos, dir)
    @directions.include?(dir) && #is valid dir
    not @board[opponent_pos].open? && #is piece extact
    @board[opponent_pos].color != @color && #is opponent extract
    @board[jump_pos].open?
  end
  
  def destroy
    @board[@pos] = nil
  end
  
  def directions
    return NORTH if @color == :white
    return SOUTH if @color == :red 
  end
  
  def premote
    @king = true
    @directions = NORTH + SOUTH
  end
  
  def slide_moves
    @directions.map do |dir| 
      Board.adj_pos(@pos, dir) 
    end.select do |pos|
      @board.open?(pos)
    end
  end
  
  def to_s
   return "K".colorize(@color) if king?
   "O".colorize(@color)   
  end
end