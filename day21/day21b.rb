require 'matrix'

def paths_from_to(from, to, numeric: false)
  moves = {
    '<' => Vector[0, -1],
    '>' => Vector[0, 1],
    '^' => Vector[-1, 0],
    'v' => Vector[1, 0]
  }

  numeric_grid = {
    '7' => Vector[0, 0],
    '8' => Vector[0, 1],
    '9' => Vector[0, 2],
    '4' => Vector[1, 0],
    '5' => Vector[1, 1],
    '6' => Vector[1, 2],
    '1' => Vector[2, 0],
    '2' => Vector[2, 1],
    '3' => Vector[2, 2],
    '0' => Vector[3, 1],
    'A' => Vector[3, 2]
  }

  directional_grid = {
    '<' => Vector[1, 0],
    '>' => Vector[1, 2],
    '^' => Vector[0, 1],
    'v' => Vector[1, 1],
    'A' => Vector[0, 2]
  }

  blank_key = numeric ? Vector[3, 0] : Vector[0, 0]
  grid = numeric ? numeric_grid : directional_grid

  dy, dx = (grid[to] - grid[from]).to_a

  y_moves = dy.positive? ? 'v' * dy.abs : '^' * dy.abs
  x_moves = dx.positive? ? '>' * dx.abs : '<' * dx.abs

  valid_paths = (x_moves + y_moves).chars.permutation.to_a.uniq.select do |move_seq|
    current_pos = grid[from].dup
    valid = true

    move_seq.each do |move|
      current_pos += moves[move]
      if current_pos == blank_key
        valid = false
        break
      end
    end

    valid
  end

  valid_paths.map { |path| "#{path.join}A" }
end

def shortest_sequence(path, path_mem, lim, depth = 0)
  mem_key = [path, depth, lim].to_s
  return path_mem[mem_key] if path_mem[mem_key]

  current = 'A'
  length = 0
  path.chars.each do |step|
    moves = depth.zero? ? paths_from_to(current, step, numeric: true) : paths_from_to(current, step)

    if depth == lim
      length += (moves[0] || 'A').length
    else
      length += moves.map { |move| shortest_sequence(move, path_mem, lim, depth + 1) }.min
    end

    current = step
  end
  path_mem[mem_key] = length
  length
end

def roboception(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  path_mem = {}
  complexity = 0

  input.lines.each do |line|
    numeric = line.strip.match(/\d+/).to_s.to_i
    button_sequence = shortest_sequence(line.strip, path_mem, 25)
    complexity += numeric * button_sequence
  end

  complexity
end

puts roboception('day21-input.txt')
