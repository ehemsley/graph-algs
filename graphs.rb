class Vertex
  attr_accessor :name, :label, :scheme_ordering, 
                :neighbors_to_check, :neighborhood,
                :clique_size

  def initialize(vertex)
    @name = vertex.to_s
  end
end

class Graph < Hash

  attr_accessor :vertices, :edges 

  def initialize(hash)
    raw_vertices = hash.keys
    @vertices = []
    raw_vertices.each do |vertex| 
      @vertices << Vertex.new(vertex)
    end
    @vertices.each { |v| self[v]= [] }
    @vertices.each do |v|
      v_row = hash.find { |vertex, n| v.name == vertex.to_s }
      raw_neighbors = v_row[1]
      raw_neighbors.each do |raw_neighbor|
        neighbor = @vertices.find { |vert| vert.name == raw_neighbor.to_s }
        if !neighbor.nil?
          self[v] << neighbor
        end
      end
    end
    get_neighbors
  end

  class Edge
  end

  def get_neighbors
    self.each { |vertex, neighbors| vertex.neighborhood = neighbors }
  end

  def print_graph
    self.each { |vertex,edges| print "   #{vertex.name} => "; edges.each { |edge| print "#{edge.name} " }; puts }
  end

end
