# Recognizing Triangulated Graphs by
# Lexicographic Breadth-First Search
require './graphs'

def lexicographic_bfs(graph)
  graph.keys.each { |vertex| vertex.label = '' }
  unprocessed_vertices = graph.keys

  for scheme_order in (graph.size).downto(1)
    largest = select_largest_label(unprocessed_vertices)
    unprocessed_vertices.delete(largest)
    largest.scheme_ordering = scheme_order
    update_labels(graph, unprocessed_vertices, largest, scheme_order)
  end

  perfect_elimination_scheme = graph.keys.sort { |a,b| a.scheme_ordering <=> b.scheme_ordering }
end

def select_largest_label(vertices)
  lexicographic_ordering = vertices.sort { |a,b| b.label <=> a.label }
  return lexicographic_ordering.first
end

def update_labels(neighborhood, unprocessed_vertices, largest_labeled_vertex, label)
  unprocessed_vertices.each do |unprocessed_vertex| 
    if(neighborhood[largest_labeled_vertex].include?(unprocessed_vertex))
        unprocessed_vertex.label << "#{label}"
    end
  end
end

def test_perfect_elimination_scheme(graph, perfect_elimination_scheme)
  graph.each { |vertex,e| vertex.neighbors_to_check = [] }
  for i in 0..graph.size-2
    v = perfect_elimination_scheme[i]
    neighbors_removed_after_v = graph[v].select { |neighbor| v.scheme_ordering < neighbor.scheme_ordering }
    if !neighbors_removed_after_v.empty?
      neighbor_with_highest_scheme_order = neighbors_removed_after_v.min { |a,b| a.scheme_ordering <=> b.scheme_ordering }
      neighbor_with_highest_scheme_order.neighbors_to_check << neighbors_removed_after_v.delete(neighbor_with_highest_scheme_order)
    end
    if !adjacent_to_required_vertices?(v, graph)
      puts "Graph is not triangulated"
      return false
    end
  end
  puts "Graph is triangulated"
  return true
end

def adjacent_to_required_vertices?(vertex, graph)
  test = graph.clone
  test.each { |vertex, value| test[vertex] = 0 }
  vertex.neighborhood.each { |neighbor| test[neighbor] = 1 }
  vertex.neighbors_to_check.each do |better_be_there|  
    if test[better_be_there] == 0 
      return false 
    end
  end
  return true
end

def print_maximal_cliques(graph, perfect_elimination_scheme)
  chromatic_number = 1
  graph.each { |vertex,e| vertex.clique_size = 0 }
  for i in 0..graph.size-1
    v = perfect_elimination_scheme[i]
    neighbors_removed_after_v = graph[v].select { |neighbor| v.scheme_ordering < neighbor.scheme_ordering }
    if v.neighborhood.empty?
      puts "Maximal clique of size 1:"
      puts "  #{v.name}"
    end
    if !neighbors_removed_after_v.empty?
      neighbor_with_highest_scheme_order = neighbors_removed_after_v.min { |a,b| a.scheme_ordering <=> b.scheme_ordering }
      neighbor_with_highest_scheme_order.clique_size = [neighbor_with_highest_scheme_order.clique_size, neighbors_removed_after_v.size-1].max 
      if v.clique_size < neighbors_removed_after_v.size
        puts "Maximal clique of size #{neighbors_removed_after_v.size + 1}:"
        print "  #{v.name}"; neighbors_removed_after_v.each { |n| print " #{n.name}" } ; puts
        chromatic_number = [chromatic_number, neighbors_removed_after_v.size+1].max
      end
    end
  end
  puts "******************************"
  puts "The chromatic number is: #{chromatic_number}"
  puts "******************************"
end

def print_scheme(pes)
  pes.each { |vertex| print "   #{vertex.name}" }
end

graph = Graph.new({
  'a' => ['b','c','d','e'],
  'b' => ['a','c','d','e'],
  'c' => ['a','b','d','f'],
  'd' => ['a','b','c'],
  'e' => ['a','b'],
  'f' => ['c'],
  'g' => []
})

pes = lexicographic_bfs(graph)
puts "Adjacency List:"
graph.print_graph
puts "Perfect Elimination Scheme: "
print_scheme(pes)
puts
test_perfect_elimination_scheme(graph, pes)
print_maximal_cliques(graph, pes)
