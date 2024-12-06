def count_steps
  obstacles, grid_size, direction, start_y, start_x = parse_input

  guard = Guard.new(direction, start_y, start_x, obstacles, grid_size)

  guard.move until guard.leaving_lab?

  puts "Part 1: #{guard.visited.length}"

  loops = count_loops(guard.visited - [[start_y, start_x]], obstacles, direction, start_y, start_x, grid_size)
  print "\r" + " " * 80 + "\rPart 2: #{loops}\n"
end

def count_loops(visited, obstacles, direction, start_y, start_x, grid_size)
  loops = 0
  visited.each do |candidate|
    print "\rLoops found: #{loops}"
    guard = Guard.new(direction, start_y, start_x, obstacles + [candidate], grid_size)
    loops += test_candidate(guard, obstacles + [candidate], grid_size)
    STDOUT.flush
  end
  loops
end

def test_candidate(guard, obstacles, grid_size)
  until guard.leaving_lab?
    guard.move
    return 1 if guard.looped?
  end
  0
end

class Guard
  attr_reader :visited, :direction, :backtrack

  DIRECTIONS = {
    'up' => { turn: 'right', next_pos: [-1, 0]},
    'right' => { turn: 'down', next_pos: [0, 1] },
    'down' => { turn: 'left', next_pos: [1, 0]},
    'left' => { turn: 'up', next_pos: [0, -1]}
  }

  def initialize(direction, y, x, obstacles, grid_size)
    @direction = direction
    @y = y
    @x = x
    @visited = Set[[y, x]]
    @backtrack = Set[]
    @obstacles = obstacles
    @grid_size = grid_size
  end

  def turn
    @direction = DIRECTIONS[@direction][:turn]
  end

  def move
    while @obstacles.include?(next_pos)
      @backtrack.add([@y, @x, @direction])
      turn
    end
    step
  end

  def step
    @backtrack.add([@y, @x, @direction])
    dy, dx = DIRECTIONS[@direction][:next_pos]
    @y += dy
    @x += dx
    @visited.add([@y, @x])
  end

  def next_pos
    dy, dx = DIRECTIONS[@direction][:next_pos]
    [@y + dy, @x + dx]
  end

  def position
    [@y, @x]
  end

  def looped?
    @backtrack.include?([@y, @x, @direction])
  end

  def leaving_lab?
    !next_pos.all? { |pos| (0...@grid_size).include?(pos) }
  end
end

def parse_input
  obstacles = Set[]
  grid_size = 0
  dir_symbols = { '>' => 'right', '^' => 'up', '<' => 'left', 'v' => 'down' }

  direction, start_y, start_x = nil, 0, 0

  File.readlines('day6-input.txt').each_with_index do |line, y|
    grid_size += 1
    line.chars.each_with_index do |char, x|
      if char == '#'
        obstacles << [y, x]
      elsif dir_symbols.keys.include?(char)
        direction, start_y, start_x = dir_symbols[char], y, x
      end
    end
  end

  [obstacles, grid_size, direction, start_y, start_x]
end

count_steps
