def get_antinode_count
  towers, grid_size = parse_input
  antinodes = []


  towers.each do |freq, towers|
    ants = towers.combination(2).each do |a, b|
      antinodes += get_all_line_coordinates(a[0], a[1], b[0], b[1], grid_size)
    end
  end

  antinodes.uniq.count
end

def parse_input
  grid_size = 0
  hash_of_towers = {}

  File.readlines('day8-input.txt').each_with_index do |line, y|
    grid_size += 1
    line.chars.each_with_index do |char, x|
      next if char == '.' || char == "\n"
      hash_of_towers[char] ? hash_of_towers[char].append([x, y]) : hash_of_towers[char] = [[x, y]]
    end
  end

  [hash_of_towers, grid_size]
end

# Method to get all valid coordinates on a line passing through two points
def get_all_line_coordinates(x1, y1, x2, y2, grid_size)
  coordinates = []

  dx = x2 - x1
  dy = y2 - y1

  gcd = dx.gcd(dy)

  step_x = dx / gcd
  step_y = dy / gcd

  # Get points forward from point 1
  x, y = x1, y1
  while x >= 0 && x < grid_size && y >= 0 && y < grid_size
    coordinates << [x, y]
    x += step_x
    y += step_y
  end

  # Get points backwards from point 1
  x, y = x1 - step_x, y1 - step_y
  while x >= 0 && x < grid_size && y >= 0 && y < grid_size
    coordinates << [x, y]
    x -= step_x
    y -= step_y
  end

  coordinates.uniq
end

puts get_antinode_count
