def bron_kerbosch_pivot(current_clique, potential_nodes, processed, adjacency, cliques)
  if potential_nodes.empty? && processed.empty?
    cliques.append(current_clique.clone)
    return
  end

  pivot = (potential_nodes + processed.to_a).max_by { |node| adjacency[node].size }
  neighbors_of_pivot = adjacency[pivot]

  candidates = potential_nodes - neighbors_of_pivot.to_a

  candidates.each do |v|
    neighbors = adjacency[v]
    bron_kerbosch_pivot(
      current_clique + [v],
      potential_nodes & neighbors.to_a,
      processed & neighbors.to_a,
      adjacency,
      cliques
    )
    potential_nodes.delete(v)
    processed.add(v)
  end
end

def find_maximal_cliques(adjacency)
  cliques = []
  potential_nodes = adjacency.keys
  bron_kerbosch_pivot([], potential_nodes, Set.new, adjacency, cliques)
  cliques
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

def lan_password(file)
  connections = parse_input(file)
  adjacency = make_adjacency_list(connections)

  maximal_cliques = find_maximal_cliques(adjacency)

  max_size = maximal_cliques.map(&:size).max
  max_cliques = maximal_cliques.select { |clique| clique.size == max_size }

  max_cliques.first.sort.join(',')
end

puts lan_password('day23-input.txt')
