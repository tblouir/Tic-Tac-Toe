class Game
  attr_accessor :player, :computer
  def initialize
    @human = Player.new("Human")
    @computer = Player.new("Computer")
    @board = Array.new(3) {Array.new(3, " E ")}
    @filled_spots = []
    @winner = false

    show_board()
  end

  def human_choose
    puts "\nPlease select 2 numbers: e.g '1 2'"
    choice = gets.chomp.split
    puts ""
    row = choice[0].to_i
    column = choice[1].to_i

    if @filled_spots.include?([row, column])
      puts "Spot taken, try another."
      show_board()
      human_choose()
    else
      @filled_spots << [row, column]
      @human.player_spots << [row, column]
      @board[row][column] = " O "
    end

    evaluate_winner(@human)
  end

  def computer_choose
    row = choose_random()
    column = choose_random()

    while @filled_spots.include?([row, column])
      row = choose_random()
      column = choose_random()
    end

    @filled_spots << [row, column]
    @computer.player_spots << [row, column]
    @board[row][column] = " X "
      
    evaluate_winner(@computer)
  end

  def play_game
    until @winner
      self.human_choose
      self.computer_choose
      show_board()
    end
  end

  def show_board
    @board.each do |row|
      row.each_index do |index|
        print row[index]
        print "\n" if index == 2
      end
    end
  end

  def choose_random
    rand(3).floor
  end

  def evaluate_winner(player)
    "Evaluate each row to see if there are 2 of the computer's spots, then check if any other positions in that row are taken by the player, then check diagonals"
    center = [1, 1]
    player_row_tally = Hash.new(0)
    player.player_spots.each do |array|
      player_row_tally[array[0]] += 1 if array[0]
    end
    # p "Row Tally: #{player_row_tally}"

    player_column_tally = Hash.new(0)
    player.player_spots.each do |array|
      player_column_tally[array[1]] += 1 if array[1]
    end
    # p "Column Tally: #{player_column_tally}"

    player_diagonal_tally = Hash.new(0)
    player.player_spots.each do |array|
      if array[0] == array[1]
        player_diagonal_tally[:same] += 1
      end

      if array[0] == 2 || array[1] == 2
        player_diagonal_tally[:opposites] += 1
      end
    end
    player_diagonal_tally[:opposites] += 1 if player.player_spots.include?(center)
    # p "Diagonal Tally: #{player_diagonal_tally}"

    if player_row_tally.values.include?(3) || player_column_tally.values.include?(3) || player_diagonal_tally.values.include?(3)
      puts "#{player.name} is the winner!"
      @winner = true
    end
    
    if @filled_spots.length == 9
      puts "Tie!"
      @winner = true
    end
    
    player_row_tally.clear
    player_column_tally.clear
    player_diagonal_tally.clear
  end
end

class Player
  attr_accessor :player_spots
  attr_reader :name
  def initialize(name)
    @player_spots = []
    @name = name
  end
end

game = Game.new
game.play_game