require "deque"

def parse_input(file : String) : Array(Array(Char))
  input = File.read(File.join(File.dirname(__FILE__), file))

  grid = Array.new(71) { Array.new(71, '.') }

  grid[0][0] = 'S'
  grid[70][70] = 'E'

  obstacles = input.lines.first(1024).map do |line|
    line.strip.split(',').map(&.to_i)
  end

  obstacles.each do |mem|
    grid[mem[1]][mem[0]] = '#'
  end

  grid
end

# Add two sets of coordinates
def add_coords(first, second)
  first.zip(second).map { |a, b| a + b }
end

# Possible directions
def directions
  {
    '<' => [0, -1],
    '>' => [0, 1],
    'v' => [1, 0],
    '^' => [-1, 0],
  }
end

# Breadth First Search
def bfs(grid, start = [0, 0], goal = [70, 70])
  que = Deque.new([start])
  visited = Set.new([start])

  until que.empty?
    node = que.shift
    return true if node == goal

    directions.each_value do |move|
      neighbour_pos = add_coords(node, move)

      next if neighbour_pos.any? { |coord| coord > 70 || coord.negative? }

      next if grid.dig(neighbour_pos[0], neighbour_pos[1]) == '#'

      next if visited.includes?(neighbour_pos)

      que.push(neighbour_pos)
      visited.add(neighbour_pos)
    end
  end
  false
end

# Get remaining memory blocks
def parse_remaining_blocks(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  input.lines[1024..].map do |line|
    line.strip.split(',').map(&.to_i)
  end
end

grid = parse_input("day18-input.txt")

remaining_blocks = parse_remaining_blocks("day18-input.txt")

closing_block = nil

remaining_blocks.each_with_index do |block, i|
  print "\rChecking with block ##{i + 1024}: #{block}"
  grid[block[1]][block[0]] = '#'
  path = bfs(grid)
  unless path
    closing_block = block
    break
  end
end

puts "\nPath-closing block: #{closing_block}"
