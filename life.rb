GRID_SIZE = 30
class Life
  attr_accessor :grid

  def initialize
    @grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) }
  end

  def play
    gets
    transition
    display
    play
  end

  def display
    system 'clear'
    @grid.each do |rows|
      str = ''
      rows.each do |cell|
        if cell
          str << '0 '
        else
          str << '. '
        end
      end
      puts str
    end
  end

  def transition
    # Dup the grid
    new_grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) }

    # Iterate through each cells
    @grid.each_with_index do |rows, r_idx|
      rows.each_with_index do |cell, c_idx|
        neighbors_count = get_neighbor_cells([r_idx, c_idx]).count

        if cell.nil? && neighbors_count == 3 # Cell is reproduced
          new_grid[r_idx][c_idx] = 1
        elsif neighbors_count == 2 || neighbors_count == 3 # Cell lives on
          new_grid[r_idx][c_idx] = cell
        else
          new_grid[r_idx][c_idx] = nil
        end

      end
    end

    @grid = new_grid
  end

  def get_neighbor_cells(pos)
    neighbor_cells = []
    neighbor_pos = get_neighbor_pos(pos)
    neighbor_pos.each do |pos|
      cell = @grid[pos.first][pos.last]
      next if cell.nil?
      neighbor_cells << cell
    end
    neighbor_cells
  end

  def get_neighbor_pos(pos)
    curr_row = pos.first
    curr_col = pos.last
    neighboring_pos = []
    deltas = neighbor_deltas
    deltas.each do |d_row, d_col|
      new_row = curr_row + d_row
      new_col = curr_col + d_col
      new_pos = [new_row, new_col]
      next if is_outbound?(new_pos)
      neighboring_pos << new_pos
    end
    neighboring_pos
  end

  def neighbor_deltas
    [0, -1, -1, 1, 1].permutation(2).to_a.uniq
  end

  def is_outbound?(pos)
    row = pos.first
    col = pos.last
    return true if row < 0 || row >= GRID_SIZE || col < 0 || col >= GRID_SIZE
    false
  end

  def create_blinker(pos)
    row = pos.first
    col = pos.last
    @grid[row-1][col] = 1
    @grid[row][col] = 1
    @grid[row+1][col] = 1
  end

  def create_toad(pos)
    row = pos.first
    col = pos.last

    @grid[row][col] = 1
    @grid[row+1][col] = 1
    @grid[row][col+1] = 1
    @grid[row+1][col+1] = 1
    @grid[row][col+2] = 1
    @grid[row+1][col-1] = 1
  end

  def create_beacon(pos)
    row = pos.first
    col = pos.last

    @grid[row][col] = 1
    @grid[row+1][col] = 1
    @grid[row][col+1] = 1

    @grid[row+3][col+2] = 1
    @grid[row+2][col+3] = 1
    @grid[row+3][col+3] = 1
  end

  def create_glider(pos)
    row = pos.first
    col = pos.last

    @grid[row][col] = 1
    @grid[row+1][col] = 1
    @grid[row+2][col] = 1
    @grid[row+2][col-1] = 1
    @grid[row+1][col-2] = 1
  end

  def create_star(pos)
    row = pos.first
    col = pos.last

    @grid[row][col] = 1
    @grid[row-1][col] = 1
    @grid[row+1][col] = 1
    @grid[row][col-1] = 1
    @grid[row][col+1] = 1
  end

end

life = Life.new
life.create_blinker([3, 3])
life.create_toad([6, 6])
life.create_beacon([10, 2])
life.create_glider([0, 10])
life.create_star([20, 8])
life.display
life.play
