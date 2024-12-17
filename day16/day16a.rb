require_relative '../lib/heap'

# Parse grid from file with given path
def parse_input(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  start = nil
  goal = nil
  grid = []
  input.lines.each_with_index do |line, y|
    start = [y, line.index('S')] if line.include?('S')
    goal = [y, line.index('E')] if line.include?('E')

    grid.append(line.strip.chars)
  end

  [grid, start, goal]
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

# Reversal of each direction
def opposites
  {
    '<' => '>',
    '>' => '<',
    'v' => '^',
    '^' => 'v'
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
  start_node = { position: start, g_cost: 0, direction: '>', parent: nil, f_cost: manhattan_distance(start, goal) }
  open.push(start_node)

  # Closed as a hash of [y, x, dir] => g_cost
  closed = {}

  until open.empty?
    # Pop node with minimum f-cost
    current = open.extract_min

    # Return if current is the goal position
    return current if current[:position] == goal

    current_key = [current[:position], current[:direction]].flatten

    # Next if better path already found
    next if closed.key?(current_key) && closed[current_key] <= current[:g_cost]

    closed[current_key] = current[:g_cost]

    directions.each do |dir, move|
      # Don't consider turning back
      next if dir == opposites[current[:direction]]

      neighbour_pos = add_coords(current[:position], move)

      # Check traversability
      next if grid.dig(*neighbour_pos) == '#'

      # Added cost either 1 if moving forward or 1001 if turning before moving
      move_cost = dir == current[:direction] ? 1 : 1001

      g_cost = current[:g_cost] + move_cost
      h_cost = manhattan_distance(goal, neighbour_pos)
      f_cost = g_cost + h_cost

      neighbour_key = [neighbour_pos, dir].flatten

      # Add to open if this path is better or new
      if !closed.key?(neighbour_key) || g_cost < closed[neighbour_key]
        open.push({ position: neighbour_pos, g_cost:, direction: dir, f_cost:, parent: current })
      end
    end

  end
end

grid, start, goal = parse_input('day16-input.txt')

puts a_star(start, goal, grid)[:g_cost]
