def sum_fences
  grid = File.readlines('day12-input.txt').map { |line| line.strip.chars }

  visited = []
  map = []

  grid.each_with_index do |row, y|
    row.each_with_index do |plot, x|
      next if visited.include?([y, x])

      puts "Looking at [#{y}, #{x}]"

      segment = [0, 0]
      que = Queue.new
      que.push([y, x])
      visited.append([y, x])

      until que.empty?
        cy, cx = que.deq
        segment[0] += 1
        neighbours = 4

        [[-1, 0], [0, -1], [1, 0], [0, 1]].each do |dy, dx|
          next unless grid.dig(cy + dy, cx + dx) == plot && cy + dy >= 0 && cx + dx >= 0

          neighbours -= 1
          next if visited.include?([cy + dy, cx + dx])

          que.push([cy + dy, cx + dx])
          visited.append([cy + dy, cx + dx])
        end
        segment[1] += neighbours

      end
      map.append(segment)
    end
  end

  sum = 0
  map.each do |sz, fence|
    sum += sz * fence
  end
  sum
end

puts sum_fences
