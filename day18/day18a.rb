require_relative '../lib/heap'

## Basically a copy of the solution to day16a

# Parse grid from file with given path
def parse_input(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  start = [0, 0]
  goal = [70, 70]

  grid = Array.new(71) { Array.new(71, '.') }

  grid[0][0] = 'S'
  grid[70][70] = 'E'

  obstacles = input.lines.first(1024).map do |ln|
    ln.strip.split(',').map(&:to_i)
  end

  obstacles.each { |mem| grid[mem[1]][mem[0]] = '#' }

  [grid, start, goal]
end

# Get remaining memory blocks
def parse_remaining_blocks(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  input.lines[1024..].map do |ln|
    ln.strip.split(',').map(&:to_i)
  end
end

# Possible directions
def directions
  {
    '<' => [0, -1],
    '>' => [0, 1],
    'v' => [1, 0],
    '^' => [-1, 0]
  }
end

# Use manhattan distance (only orthogonal movements)
def manhattan_distance(first, second)
  (second[0] - first[0]).abs + (second[1] - first[1]).abs
end

# Add two sets of coordinates
def add_coords(first, second)
  first.zip(second).map { |a, b| a + b }
end

def a_star(start, goal, grid)
  # Initialize heap with starting node
  open = Heap.new { |a, b| a[:f_cost] < b[:f_cost] }
  start_node = { position: start, g_cost: 0, parent: nil, f_cost: manhattan_distance(start, goal) }
  open.push(start_node)

  # Closed as a hash of [y, x, dir] => g_cost
  closed = {}

  until open.empty?
    # Pop node with minimum f-cost
    current = open.extract_min

    # Return if current is the goal position
    return current if current[:position] == goal

    current_key = [current[:position]]

    # Next if better path already found
    next if closed.key?(current_key) && closed[current_key] <= current[:g_cost]

    closed[current_key] = current[:g_cost]

    directions.each_value do |move|
      neighbour_pos = add_coords(current[:position], move)

      next if neighbour_pos.any? { |coord| coord > 70 || coord.negative? }

      # Check traversability
      next if grid.dig(*neighbour_pos) == '#'

      move_cost = 1

      g_cost = current[:g_cost] + move_cost
      h_cost = manhattan_distance(goal, neighbour_pos)
      f_cost = g_cost + h_cost

      neighbour_key = [neighbour_pos]

      # Add to open if this path is better or new
      if !closed.key?(neighbour_key) || g_cost < closed[neighbour_key]
        open.push({ position: neighbour_pos, g_cost:, f_cost:, parent: current })
      end
    end

  end
end

def reconstruct_path(node)
  path = []
  current = node
  while current
    path.append(current[:position])
    current = current[:parent]
  end
  path.reverse
end

grid, start, goal = parse_input('day18-input.txt')

puts a_star(start, goal, grid)[:g_cost]
