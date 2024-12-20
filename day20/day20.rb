require_relative '../lib/heap'

## A* again

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

  # Closed as a hash of [y, x] => g_cost
  closed = {}

  until open.empty?
    grid_size = grid.length - 1

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

      next if neighbour_pos.any? { |coord| coord > grid_size || coord.negative? }

      # Check traversability
      next if grid.dig(*neighbour_pos) == '#'

      g_cost = current[:g_cost] + 1
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
    path.append([current[:position], current[:g_cost]].flatten)
    current = current[:parent]
  end
  path.reverse
end

def find_shortcuts(points, phase_distance = 2, min_shortcut_length = 100)
  valid_shortcuts = 0

  (0...points.length).each do |i|
    ((i + 1)...points.length).each do |j|
      point_a = points[i]
      point_b = points[j]

      distance = manhattan_distance(point_a, point_b)
      original_cost = point_b[2] - point_a[2]

      cost_reduction = original_cost - distance

      valid_shortcuts += 1 if distance <= phase_distance && cost_reduction >= min_shortcut_length
    end
  end

  valid_shortcuts
end

grid, start, goal = parse_input('day20-input.txt')

goal_node = a_star(start, goal, grid)

path = reconstruct_path(goal_node)

# Part 1
puts find_shortcuts(path)

# Part 2
puts find_shortcuts(path, 20)
