def count_x_mas
  input = File.read(File.join(File.dirname(__FILE__), 'day4-input.txt'))

  count = 0

  # Create a hash which returns '.' for out of bounds or negative indexes
  grid = Hash.new(Hash.new('.'))

  input.split.each_with_index do |row, y|
    hash = Hash.new('.')
    row.each_char.with_index { |char, idx| hash[idx] = char }
    grid[y] = hash
  end

  grid.each do |y, row|
    row.each do |x, ch|
      next unless ch == 'A'

      diagonals = get_diagonal_strings(grid, y, x)
      count += 1 if diagonals.count('AM') == 2 && diagonals.count('AS') == 2 && diagonals[0] != diagonals[1]
    end
  end

  count
end

# @param grid [Hash] hash containing the input grid
# @param y [Integer] row number of character
# @param x [Integer] column number of character
# @param len [Integer] how many steps to take in each diagonal direction (default: 3)
# @return [Array] Array of strings created from stepping in each of the 4 diagonal directions
def get_diagonal_strings(grid, y, x, len=1)
  directions = [
    (0..len).map { |i| grid[y + i][x + i] },
    (0..len).map { |i| grid[y - i][x - i] },
    (0..len).map { |i| grid[y + i][x - i] },
    (0..len).map { |i| grid[y - i][x + i] }
  ]

  directions.map { |dir| dir.join }
end

puts count_x_mas
