def make_fenced_regions
  input = File.read(File.join(File.dirname(__FILE__), 'day12-input.txt'))

  grid = Hash.new(Hash.new('.'))

  input.split.each_with_index do |row, y|
    hash = Hash.new('.')
    row.each_char.with_index { |char, idx| hash[idx] = char }
    grid[y] = hash
  end

  visited = Set.new
  map = []

  grid.each do |y, row|
    row.each do |x, plot|
      next if visited.include?([y, x])

      que = Queue.new
      que.push([y, x])
      visited.add([y, x])
      segment = []

      until que.empty?
        cy, cx = que.deq
        segment.append([cy, cx])

        [[-1, 0], [0, -1], [1, 0], [0, 1]].each do |dy, dx|
          if grid.dig(cy + dy, cx + dx) == plot && !visited.include?([cy + dy, cx + dx])
            que.push([cy + dy, cx + dx])
            visited.add([cy + dy, cx + dx])
          end
        end
      end
      map.append(segment)
    end
  end

  map
end

def count_corners(coords)
  filled = coords.to_set

  edge_offsets = {
    'top' => ->(y, x) { [[y, x], [y, x + 1]] },
    'right' => ->(y, x) { [[y, x + 1], [y + 1, x + 1]] },
    'bottom' => ->(y, x) { [[y + 1, x + 1], [y + 1, x]] },
    'left' => ->(y, x) { [[y + 1, x], [y, x]] }
  }

  neighbor_deltas = {
    'top' => [-1, 0],
    'right' => [0, 1],
    'bottom' => [1, 0],
    'left' => [0, -1]
  }

  outer_edges = Set.new

  filled.each do |y, x|
    neighbor_deltas.each do |direction, (dy, dx)|
      neighbor = [y + dy, x + dx]
      next if filled.include?(neighbor)

      edge = edge_offsets[direction].call(y, x)
      sorted_edge = edge.sort
      outer_edges.add(sorted_edge)
    end
  end

  vertex_to_edges = Hash.new { |hash, key| hash[key] = [] }

  outer_edges.each do |edge|
    v1, v2 = edge
    vertex_to_edges[v1].append(edge)
    vertex_to_edges[v2].append(edge)
  end

  corners = 0

  vertex_to_edges.each do |vertex, edges|
    perpendicular_pairs = edges.combination(2).count do |edge1, edge2|
      vector = lambda do |edge, vertex|
        if edge[0] == vertex
          [edge[1][0] - edge[0][0], edge[1][1] - edge[0][1]]
        else
          [edge[0][0] - edge[1][0], edge[0][1] - edge[1][1]]
        end
      end

      vec1 = vector.call(edge1, vertex)
      vec2 = vector.call(edge2, vertex)

      dot_product = vec1[0] * vec2[0] + vec1[1] * vec2[1]
      dot_product.zero?
    end

    case edges.size
    when 2
      corners += 1 if perpendicular_pairs == 1
    when 4
      corners += 2 if perpendicular_pairs >= 2
    end
  end

  corners
end

regions = make_fenced_regions

fences = 0

regions.each do |region|
  fences += region.length * count_corners(region)
end

puts fences
