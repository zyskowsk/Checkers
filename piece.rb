require 'colorize'

class Piece
  attr_reader :king
  alias_method :king?, :king
  
  NORTH, SOUTH = [[-1, -1], [-1, 1]], [[1, 1], [1, -1]]
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @directions = nil
    @king = false
  end
  
  def destroy
    @board[@pos] = nil
  end
  
  def premote
    @king = true
    @directions = NORTH + SOUTH
  end
  
  def to_s
     return "K".colorize(@color) if king?
     "O".colorize(@color)   
  end
  
end