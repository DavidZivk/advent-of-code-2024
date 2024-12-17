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

# Reconstruct the path from goal to start with parent references
def reconstruct_paths(goal_node)
  paths = []
  stack = [[goal_node, []]]

  until stack.empty?
    current, path = stack.pop
    new_path = [current[:position]] + path

    if current[:parent].empty?
      paths.append(new_path)
    else
      current[:parent].each do |parent_node|
        stack.push([parent_node, new_path])
      end
    end
  end

  paths
end

def a_star(start, goal, grid)
  # Initialize heap with starting node
  open = Heap.new { |a, b| a[:f_cost] < b[:f_cost] }
  start_node = { position: start, g_cost: 0, direction: '>', parent: [] }
  start_node[:f_cost] = manhattan_distance(start, goal)
  open.push(start_node)

  # Closed as a hash of [y, x, dir] => { g_cost:, parents: }
  closed = {}

  optimal_cost = nil

  until open.empty?
    # Pop node with minimum f-cost
    current = open.extract_min

    # We can break if we start finding sub-optimal paths
    break if optimal_cost && current[:f_cost] > optimal_cost

    # Set optimal_cost once initial shortest path is found
    optimal_cost = current[:g_cost] if current[:position] == goal && optimal_cost.nil?

    current_key = [current[:position], current[:direction]]
    closed[current_key] = { g_cost: current[:g_cost], parents: [] } unless closed.key?(current_key)

    # Skip, add or replace parents depending on g_cost
    if current[:g_cost] > closed[current_key][:g_cost]
      next
    elsif current[:g_cost] == closed[current_key][:g_cost]
      closed[current_key][:parents].append(current[:parent])
    else
      closed[current_key] = { g_cost: current[:g_cost], parents: [current[:parent]] }
    end

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

      neighbour_key = [neighbour_pos, dir]

      # Only consider within optimal cost once it's found
      next if optimal_cost && f_cost > optimal_cost

      if !closed.key?(neighbour_key) || g_cost <= closed[neighbour_key][:g_cost]
        open.push({ position: neighbour_pos, direction: dir, parent: [current], f_cost:, g_cost: })
      end
    end
  end

  goal_nodes = closed.select { |k, _v| k[0] == goal }.flat_map do |k, v|
    v[:parents].map { |parent| { position: k[0], direction: k[1], g_cost: v[:g_cost], parent: } }
  end

  all_paths = goal_nodes.flat_map { |goal_node| reconstruct_paths(goal_node) }

  all_paths.flatten(1).uniq
end

grid, start, goal = parse_input('day16-input.txt')

sittable_positions = a_star(start, goal, grid)

puts sittable_positions.size
