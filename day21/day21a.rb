def transitions
  transitions = {
    'A' => {
      '<' => 'v<<A',
      'v' => 'v<A',
      '^' => '<A',
      '>' => 'vA'
    },
    '^' => {
      '<' => 'v<A',
      'v' => 'vA',
      'A' => '>A',
      '>' => 'v>A'
    },
    'v' => {
      '<' => '<A',
      'A' => '^>A',
      '^' => '^A',
      '>' => '>A'
    },
    '<' => {
      'A' => '>>^A',
      'v' => '>A',
      '^' => '>^A',
      '>' => '>>A'
    },
    '>' => {
      '<' => '<<A',
      'v' => '<A',
      '^' => '<^A',
      'A' => '^A'
    }
  }
  transitions.default = 'A'
  transitions.each_key { |key| transitions[key].default = 'A' }
  transitions
end

def move_to(key, start = 'A')
  step = 'A'
  transitions[start][key].chars.map do |mv|
    m = transitions[step][mv]
    step = mv
    m
  end.join
end

def press(key)
  move_to('A', key)
end

def path_from_to(from, to)
  grid = {
    '7' => [0, 0],
    '8' => [0, 1],
    '9' => [0, 2],
    '4' => [1, 0],
    '5' => [1, 1],
    '6' => [1, 2],
    '1' => [2, 0],
    '2' => [2, 1],
    '3' => [2, 2],
    '0' => [3, 1],
    'A' => [3, 2]
  }
  start = grid[from]
  goal = grid[to]

  dy = goal[0] - start[0]
  dx = goal[1] - start[1]

  y_moves = dy.positive? ? 'v' * dy.abs : '^' * dy.abs
  x_moves = dx.positive? ? '>' * dx.abs : '<' * dx.abs

  # Prioritize vertical movement unless going top-left or passing through blank button
  if dy.negative? && dx.negative? && (!%w[A 0].include?(from) || !%w[7 4 1].include?(to))
    x_moves + y_moves
  elsif dy.positive? && dx.positive? && %w[7 4 1].include?(from) && %w[A 0].include?(to)
    x_moves + y_moves
  else
    y_moves + x_moves
  end
end

def make_pattern(code)
  paths = code.prepend('A').chars.each_cons(2).map { |from, to| path_from_to(from, to) }

  pattern = ''
  paths.each do |path|
    if path.chars.length == 1
      pattern += move_to(path)
      pattern += press(path)
    else
      pattern += move_to(path.chars.first)
      pattern += path.chars.each_cons(2).map { |pair| move_to(pair[1], pair[0]) }.join
      pattern += press(path.chars.last)
    end
  end
  pattern
end

def keypad_conundrum(file)
  input = File.read(File.join(File.dirname(__FILE__), file))
  sum = 0

  input.lines.each do |line|
    numeric = line.strip.match(/\d+/).to_s.to_i
    pattern = make_pattern(line.strip)
    sum += numeric * pattern.length
  end

  sum
end

puts keypad_conundrum('day21-input.txt')
