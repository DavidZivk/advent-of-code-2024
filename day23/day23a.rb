def find_triangles(adjacency, ordered_nodes, node_order)
  triangles = Set.new

  ordered_nodes.each do |node|
    neighbors = adjacency[node].select { |n| node_order[n] > node_order[node] }
    neighbors = neighbors.to_a.sort_by { |n| node_order[n] }

    neighbors.each do |neighbor|
      common = adjacency[node].intersection(adjacency[neighbor]).select { |n| node_order[n] > node_order[neighbor] }

      common.each do |common_neighbor|
        triangle = [node, neighbor, common_neighbor].sort
        triangles.add(triangle)
      end
    end
  end

  triangles
end

def parse_input(file)
  input = File.read(File.join(File.dirname(__FILE__), file))
  input.lines.map(&:strip)
end

def make_adjacency_list(connections)
  adjacency = Hash.new { |hash, key| hash[key] = Set.new }

  connections.each do |connection|
    a, b = connection.split('-')
    adjacency[a].add(b)
    adjacency[b].add(a)
  end

  adjacency
end

def historian_connections(file)
  connections = parse_input(file)
  adjacency = make_adjacency_list(connections)

  ordered_nodes = adjacency.keys.sort_by { |node| adjacency[node].size }

  node_order = {}
  ordered_nodes.each_with_index { |node, index| node_order[node] = index }

  triangles = find_triangles(adjacency, ordered_nodes, node_order)

  triangles.to_a.count { |tr| tr.any? { |cname| cname[0] == 't' } }
end

puts historian_connections('day23-input.txt')
