def parse_input
  input = File.read(File.join(File.dirname(__FILE__), 'day14-input.txt'))

  robots = []

  input.lines.each do |line|
    start_x, start_y, vx, vy = line.scan(/-?\d+/).map(&:to_i)
    robots.append([start_x, start_y, vx, vy])
  end

  robots
end

def print_robots(robot_coords, height, width, iter)
  system('clear') || system('cls')

  grid = Array.new(height) { Array.new(width, '.') }

  robot_coords.each do |coord|
    x, y = coord
    grid[y][x] = '#'
  end

  puts "ITERATION: #{iter}"

  grid.each do |row|
    puts row.join
  end
end

def move_robots
  robots = parse_input

  width = 101
  height = 103
  iter = 1

  loop do
    robot_coords = robots.map do |robot|
      start_x, start_y, vx, vy = robot

      pos_x = (start_x + iter * vx) % width
      pos_y = (start_y + iter * vy) % height

      [pos_x, pos_y]
    end

    print_robots(robot_coords, height, width, iter)
    sleep(0.01)

    iter += 1
  end
end

move_robots
