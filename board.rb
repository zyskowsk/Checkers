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
    x, y = [pos]
    @grid[x][y] = piece
  end
  
  def populate_board
    add_pieces(@colors.first)
    add_pieces(@colors.last)
  end
  
  def open?(pos)
    # does this space contain a Piece object of any color?
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
