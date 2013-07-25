require_relative 'piece'

class Board

  def initialize 
    @grid = (0...8).map { |row| [" "] * 8 }
    @colors = [:red, :white]
    populate_board
  end
  
  def [](pos)
    x, y = pos
    @grid[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end
  
  def populate_board
    add_pieces(@colors.first)
    add_pieces(@colors.last)
  end
  
  def open?(pos)
    not taken?(pos)
  end
  
  def taken?(pos)
    self[pos].is_a?(Piece)
  end
  
  def to_s
    board_string = "-" * 33 + "\n"
    @grid.each do |row| 
      board_string <<"| " + row.join(" | ") + " |\n"
      board_string <<  "-" * 33 + "\n"
    end
         
    board_string
  end
  
  private
  
    def self.adj_pos(pos, dir)
      x, y, dx, dy = pos + dir
      [x + dx, y + dy]
    end
    
    def self.disp(source, target)
      s_x, s_y, t_x, t_y = source + target
      [t_x - s_x, t_y - s_y]
    end
 
    def self.dir(source, target)
      disp = Board.disp(source, target)
      raise "Not on diagonal" unless disp.first.abs == disp.last.abs
      magnituted = disp.first.abs
      disp.map { |coord| coord / magnitude }
    end
    
    def self.disp(source, target)
      s_x, s_y, t_x, t_y = source + target
      [t_x - s_x, t_y - s_y]
    end
    
    def self.two_appart?(pos_1, pos_2)
      Board.disp(pos_1, pos_2).all? { |coord| coord.abs == 2 }
    end
       
    def add_pieces(color)
      rows = (color == :red ? (0..2) : (5..7))
      rows.each do |row| 
        @grid[row].map!.with_index do |_,col|
          next Piece.new(color, self, [row, col]) if (col + row).odd?
          " "
        end
      end
    end
  
    def toggle_color
      @colors == :red ? :black : :red
    end
end
