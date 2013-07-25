require 'colorize'

class Piece
  attr_reader :king, :color
  attr_accessor :pos
  alias_method :king?, :king
  
  NORTH, SOUTH = [[-1, -1], [-1, 1]], [[1, 1], [1, -1]]
  
  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @directions = directions
    @king = false
  end
  
  def can_jump?(dir) 
    opponent_pos = Board.adj_pos(@pos, dir)
    jump_pos = Board.adj_pos(opponent_pos, dir)  
    @directions.include?(dir) && #is valid dir
    @board.taken?(opponent_pos) && #is piece extact
    @board[opponent_pos].color != @color && #is opponent extract
    @board.open?(jump_pos)
  end
  
  def destroy
    @board[@pos] = " "
  end
  
  def directions
    return NORTH if @color == :white
    return SOUTH if @color == :red 
  end
  
  def preform_jump(pos)
    dir = Board.dir(@pos, pos)
    opponent_piece = @board[Board.adj_pos(@pos, dir)]
    raise "you cant jump there" unless self.can_jump?(dir)
    @board[pos] = self
    self.destroy
    opponent_piece.destroy
    self.pos = pos
  end
  
  def preform_slide(pos)
    raise "you cant slide there!" unless slide_moves.include?(pos)
    @board[pos] = self
    self.destroy
    self.pos = pos
  end
  
  def preform_moves!(move_sequence)
    return preform_slide(move_sequence.first) if move_sequence.length == 1
    move_sequence.each do |pos|
      preform_jump(pos)
    end
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
  
  def valid_move_seq?(move_sequence)
    new_board = @board.dup
    begin
      new_board[@pos].preform_moves!(move_sequence)
    rescue RuntimeError => e
      puts e.message
      return false
    else
      return true
    end
  end
  
end