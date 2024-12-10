def count_paths
  input = File.readlines('day10-input.txt').map(&:strip).map { |row| row.chars.map(&:to_i) }

  sum_of_paths = 0

  input.each_with_index do |row, y|
    row.each_with_index do |height, x|
      next unless height.zero?

      paths = 0
      stack = []
      stack.push([y, x])

      until stack.empty?
        cy, cx = stack.pop

        if input.dig(cy, cx) == 9
          paths += 1
          next
        end

        [[-1, 0], [0, -1], [1, 0], [0, 1]].each do |dx, dy|
          candidate = [cy + dy, cx + dx]
          current = [cy, cx]

          stack.push(candidate) if input.dig(*candidate) == input.dig(*current) + 1 && candidate.all? { |c| c >= 0 }
        end
      end

      sum_of_paths += paths
    end
  end

  sum_of_paths
end

puts count_paths
