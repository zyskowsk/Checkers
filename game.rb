require_relative 'board'
require_relative 'piece'

class Game
  
  def initialize
    @board = Board.new
  end
  
  def run
    current_player = @board.colors.first
    until @board.won?
      system "clear"
      puts @board
      puts "Your turn #{current_player.to_s}"
      play_turn(current_player)
      current_player = @board.toggle_color(current_player)
    end

    puts "you won #{@board.toggle_color(current_player).to_s}!"
  end
  
  def play_turn(color)
      piece = get_piece(color)
    begin
      move_sequence = get_sequence
      if move_sequence.length > 1
        multi_jump(piece, move_sequence)
      else
        piece.preform_moves(move_sequence)
      end
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end
  
  def get_piece_pos
    puts "Which piece do you want to move?"
    pos = gets.chomp.split.map { |num| Integer(num) }
    raise "Only two corrdinates please" unless pos.length == 2
    
    pos
  end
  
  def get_piece(color)
    begin
      pos = get_piece_pos
      piece = @board.get_piece(pos, color)
    rescue InvalidPieceError, ArgumentError, StandardError => e
      puts e.message
      retry
    end
    
    piece
  end
  
  def get_sequence
    begin
      puts "please give a sequence of moves"
      sequence = gets.chomp.scan(/\d\s\d/).map do |pos|
        pos.split.map { |num| Integer(num) } 
      end
    rescue ArgumentError => e
      e.message
      retry
    end
    
    if sequence.none? { |pair| pair.length == 2 } || sequence.empty?
      raise InvalidMoveError.new "invalid input!"
    end
    
    sequence
  end 
  
  def multi_jump(piece, move_sequence)
    until move_sequence.empty?
      system "clear"
      puts @board
      pos = move_sequence.shift
      piece.preform_jump(pos)
      sleep 0.5
    end
  end
end