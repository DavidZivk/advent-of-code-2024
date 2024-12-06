def count_steps
  input = File.read(File.join(File.dirname(__FILE__), 'day6-input.txt'))

  grid = input.split.map(&:chars)
  grid_size = grid.length

  guard = make_guard(input.gsub("\n", ''), grid_size)

  while guard.next_pos.all? { |pos| (0...grid_size).include?(pos) }
    guard.turn if grid.dig(*guard.next_pos) == '#'
    guard.move
  end

  guard.visited.uniq.length
end


def make_guard(input, grid_size)
  Guard.new(*find_guard(input, grid_size))
end

def find_guard(input, grid_size)
  symbols = { '>' => 'right', '^' => 'up', '<' => 'left', 'v' => 'down' }
  symbols.each_key do |dir|
    position = input.index(dir)
    return [symbols[dir], position / grid_size, position % grid_size] if position
  end
end


class Guard
  attr_reader :visited

  DIRECTIONS = {
    'up' => { turn: 'right', next_pos: [-1, 0]},
    'right' => { turn: 'down', next_pos: [0, 1] },
    'down' => { turn: 'left', next_pos: [1, 0]},
    'left' => { turn: 'up', next_pos: [0, -1]}
  }

  def initialize(direction, y, x)
    @direction = direction
    @y = y
    @x = x
    @visited = [[y, x]]
  end

  def turn
    @direction = DIRECTIONS[@direction][:turn]
  end

  def move
    dy, dx = DIRECTIONS[@direction][:next_pos]
    @y += dy
    @x += dx
    @visited.append([@y, @x])
  end

  def next_pos
    dy, dx = DIRECTIONS[@direction][:next_pos]
    [@y + dy, @x + dx]
  end

  def position
    [@y, @x]
  end
end

puts count_steps
