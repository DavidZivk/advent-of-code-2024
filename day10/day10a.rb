def count_trailheads
  input = File.readlines('day10-input.txt').map(&:strip).map { |row| row.chars.map(&:to_i) }

  sum_of_trailheads = 0

  input.each_with_index do |row, y|
    row.each_with_index do |height, x|
      next unless height.zero?

      trailheads = 0
      que = Queue.new
      que.push([y, x])
      visited = [[y, x]]

      until que.empty?
        cy, cx = que.deq

        if input.dig(cy, cx) == 9
          trailheads += 1
          next
        end

        [[-1, 0], [0, -1], [1, 0], [0, 1]].each do |dx, dy|
          candidate = [cy + dy, cx + dx]
          current = [cy, cx]

          if input.dig(*candidate) == input.dig(*current) + 1 && !visited.include?(candidate) && candidate.all? { |c| c >= 0 }
            que.push(candidate)
            visited.append(candidate)
          end
        end
      end

      sum_of_trailheads += trailheads
    end
  end

  sum_of_trailheads
end

puts count_trailheads
