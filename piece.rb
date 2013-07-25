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
    #is dir in directions?
    opponent_pos = Piece.adj_pos(@pos, dir)
    jump_pos = Piece.adj_pos(opponent_pos, dir)
    #does oppoent_pos contain an opponent?
    # is jump pos empty ?
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