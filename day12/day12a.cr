require "deque"

# Possible directions
def directions
  {
    "left"  => [0, -1],
    "down"  => [1, 0],
    "up"    => [-1, 0],
    "right" => [0, 1],
  }
end

# Add two sets of coordinates
def add_coords(first, second)
  first.zip(second).map { |a, b| a + b }
end

# Sum fence borders
def sum_fences
  grid = File.read_lines("day12-input.txt").map(&.strip.chars)

  visited = Set(Array(Int32)).new
  map = [] of Array(Int32)

  grid.each_with_index do |row, y|
    row.each_with_index do |plot, x|
      current_pos = [y, x]
      next if visited.includes?(current_pos)

      que = Deque.new([current_pos])
      visited.add([y, x])
      segment = [0, 0]

      until que.empty?
        pos = que.shift
        segment[0] += 1
        neighbours = 4

        directions.each_value do |move|
          movec = add_coords(pos, move)

          next unless grid.dig?(movec[0], movec[1]) == plot && movec.all? { |coord| coord >= 0 }

          neighbours -= 1
          next if visited.includes?(movec)

          que.push(movec)
          visited.add(movec)
        end
        segment[1] += neighbours
      end
      map << segment
    end
  end

  sum = 0
  map.each do |pair|
    sum += pair[0] * pair[1]
  end
  sum
end

puts sum_fences
