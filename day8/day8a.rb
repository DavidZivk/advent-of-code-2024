def get_antinode_count
  towers, grid_size = parse_input
  antinodes = []


  towers.each do |freq, towers|
    ants = towers.permutation(2).each do |a, b|
      diff = [a[0] - b[0], a[1] - b[1]]
      antinodes.append([a[0] + diff[0], a[1] + diff[1]])
    end
  end

  antinodes_inside_grid = antinodes.select do |first, second|
    first.between?(0, 49) && second.between?(0, 49)
  end

  antinodes_inside_grid.uniq.count
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


puts get_antinode_count
