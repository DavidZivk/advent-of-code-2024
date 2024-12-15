# Simplify adding coords
module CoordStuff
  def add_coords(other)
    zip(other).map { |a, b| a + b }
  end
end
Array.class_eval { include CoordStuff }

# Parse input
def parse_input
  input = File.read(File.join(File.dirname(__FILE__), 'day15-input.txt'))

  grid = []

  robot_y = 0
  robot_x = 0

  input.split("\n\n")[0].lines.each_with_index do |line, y|
    row = []
    line.strip.chars.each_with_index do |ch, _x|
      case ch
      when '#' then row.append('#', '#')
      when 'O' then row.append('[', ']')
      when '.' then row.append('.', '.')
      when '@'
        if line.include?('@')
          robot_y = y
          robot_x = line.index('@') * 2
        end
        row.append('@', '.')
      end
    end
    grid.append(row)
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

    # Horizontal movement (stays the same)
    if ['<', '>'].include?(move) && ['[', ']'].include?(grid[ry + mv[0]][rx + mv[1]])
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
        swap = grid[box[0] + mv[0]][box[1] + mv[1]]
        grid[box[0] + mv[0]][box[1] + mv[1]] = grid[box[0]][box[1]]
        grid[box[0]][box[1]] = swap
      end

      grid[ry + mv[0]][rx + mv[1]] = '@'
      grid[ry][rx] = '.'
      ry += mv[0]
      rx += mv[1]

    # Vertical movement
    else
      robot = [ry, rx]
      box = robot.add_coords(mv)
      path_clear = true
      to_shift = [box]
      current_row = [box]

      # Add initial box
      if grid.dig(*box) == '['
        to_shift.append(box.add_coords(directions['>']))
        current_row.append(box.add_coords(directions['>']))
      elsif grid.dig(*box) == ']'
        to_shift.append(box.add_coords(directions['<']))
        current_row.append(box.add_coords(directions['<']))
      end

      # Check for adjacent boxes
      loop do
        new_row = []
        current_row.each do |adj|
          case grid.dig(*adj.add_coords(mv))
          when '#'
            path_clear = false
            break
          when '['
            to_shift.append(adj.add_coords(mv))
            new_row.append(adj.add_coords(mv))

            to_shift.append(adj.add_coords(mv).add_coords(directions['>']))
            new_row.append(adj.add_coords(mv).add_coords(directions['>']))
          when ']'
            to_shift.append(adj.add_coords(mv))
            new_row.append(adj.add_coords(mv))

            to_shift.append(adj.add_coords(mv).add_coords(directions['<']))
            new_row.append(adj.add_coords(mv).add_coords(directions['<']))
          end
        end

        break if new_row.empty? || !path_clear

        current_row = new_row
      end

      # Shift all if path clear
      if path_clear
        to_shift.uniq.reverse.each do |box|
          swap = grid.dig(*box.add_coords(mv))
          grid[box[0] + mv[0]][box[1] + mv[1]] = grid[box[0]][box[1]]
          grid[box[0]][box[1]] = swap
        end

        grid[ry + mv[0]][rx + mv[1]] = '@'
        grid[ry][rx] = '.'
        ry += mv[0]
        rx += mv[1]
      end
    end
  end

  grid
end

# Calculate GPS value
def calculate_gps_sum(grid)
  sum = 0
  grid.each_with_index do |row, y|
    row.each_with_index do |ch, x|
      sum += 100 * y + x if ch == '['
    end
  end
  sum
end

final_grid = move_robot

gps = calculate_gps_sum(final_grid)

puts gps
