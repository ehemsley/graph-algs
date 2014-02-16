# Recognizing Triangulated Graphs by
# Lexicographic Breadth-First Search

class Vertex
    attr_accessor :name, :label, :scheme_ordering

    def initialize(name)
        @name = name
    end
end

def lexicographic_bfs(graph)
    graph.keys.each { |vertex| vertex.label = '' }
    unprocessed_vertices = graph.keys

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

    for scheme_order in (graph.size).downto(1)
        largest = select_largest_label(unprocessed_vertices)
        unprocessed_vertices.delete(largest)
        largest.scheme_ordering = scheme_order
        update_labels(graph, unprocessed_vertices, largest, scheme_order)
    end

    perfect_elimination_scheme = graph.keys.sort { |a,b| a.scheme_ordering <=> b.scheme_ordering }
    return perfect_elimination_scheme
end


a = Vertex.new('a')
b = Vertex.new('b')
c = Vertex.new('c')
d = Vertex.new('d')
e = Vertex.new('e')
f = Vertex.new('f')
g = Vertex.new('g')

graph = {
    a => [b,c,d,f],
    b => [a,c,d,f,g],
    c => [a,b,d,e],
    d => [a,b,c,g],
    e => [c],
    f => [a,b],
    g => [b,d]
}

pes = lexicographic_bfs(graph)
puts "Adjacency List:"
graph.each { |vertex,edges| print "   #{vertex.name} => "; edges.each { |edge| print "#{edge.name} " }; puts }
puts "Perfect Elimination Scheme: "
pes.each { |vertex| print "   #{vertex.name}" }
puts
