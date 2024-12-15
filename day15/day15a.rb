# Parse input
def parse_input
  input = File.read(File.join(File.dirname(__FILE__), 'day15-input.txt'))

  grid = []

  robot_y = 0
  robot_x = 0

  input.split("\n\n")[0].lines.each_with_index do |line, y|
    if line.include?('@')
      robot_y = y
      robot_x = line.index('@')
    end
    grid.append(line.strip.chars)
  end

  moves_list = input.split("\n\n")[1].gsub("\n", '')

  [grid, robot_y, robot_x, moves_list]
end

# Move robot according to directions from input
def move_robot
  grid, ry, rx, moves_list = parse_input

  directions = {
    '<' => [0, -1],
    '>' => [0, 1],
    'v' => [1, 0],
    '^' => [-1, 0]
  }

  moves_list.chars.each do |move|
    mv = directions[move]
    next if grid[ry + mv[0]][rx + mv[1]] == '#'

    if grid[ry + mv[0]][rx + mv[1]] == '.'
      grid[ry + mv[0]][rx + mv[1]] = '@'
      grid[ry][rx] = '.'
      ry += mv[0]
      rx += mv[1]
      next
    end

    next unless grid[ry + mv[0]][rx + mv[1]] == 'O'

    space_found = false
    step = 1

    to_shift = []
    mv[0..]

    while grid[ry + mv[0] * step][rx + mv[1] * step] != '#'
      if grid[ry + mv[0] * step][rx + mv[1] * step] == '.'
        space_found = true
        break
      end
      to_shift.append([ry + mv[0] * step, rx + mv[1] * step])
      step += 1
    end

    next unless space_found

    to_shift.reverse.each do |box|
      grid[box[0] + mv[0]][box[1] + mv[1]] = 'O'
      grid[box[0]][box[1]] = '.'
    end

    grid[ry + mv[0]][rx + mv[1]] = '@'
    grid[ry][rx] = '.'
    ry += mv[0]
    rx += mv[1]
  end

  grid
end

# Calcuate GPS value
def calculate_gps_sum(grid)
  sum = 0
  grid.each_with_index do |row, y|
    row.each_with_index do |ch, x|
      sum += 100 * y + x if ch == 'O'
    end
  end
  sum
end

final_grid = move_robot

gps = calculate_gps_sum(final_grid)

puts gps
