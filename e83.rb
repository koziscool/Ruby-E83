
require './e83_data.rb'
require './graph.rb'

VertexInfo = Struct.new( :key, :min_path_weight, :min_path, :weight ) do

  def to_s
    "key: #{key} weight: #{weight}  min path weight: #{min_path_weight}"
  end

  def min_path_string
    ret_string = "[ "
    min_path.each do | point |
      ret_string = ret_string + "#{point} " 
    end
    ret_string = ret_string + " ]"
    ret_string
  end
end


class PathFinder
  SOME_BIG_NUMBER = 10000000000

  def initialize( graph, origin_key, terminal_key )
    @graph = graph
    @our_vertex_hash = {}
    build_vertex_info
    @origin = @our_vertex_hash[ origin_key ]
    @origin.min_path_weight = @origin.weight
    @improved_path_nodes = [ origin_key ]
    @terminal = @our_vertex_hash[ terminal_key ]
  end

  def build_vertex_info
    @graph.nodes.each do |key, node|
      v_info = VertexInfo.new( node.key, SOME_BIG_NUMBER, [], node.weight )
      @our_vertex_hash[ node.key ] = v_info
    end
  end

  def find_min_path
    until @improved_path_nodes.empty?
      main_loop
    end
    puts @terminal.min_path_string
    puts @terminal.min_path_string.length
    @terminal.min_path_weight
  end 

  def main_loop
    updates = []

    @improved_path_nodes.each do | node_key |
      node = @our_vertex_hash[ node_key ]
      node_neighbors = @graph.nodes[ node_key ].neighbors
      node_neighbors.each do | neighbor_key |
        neighbor = @our_vertex_hash[ neighbor_key ]
        new_path_weight = node.min_path_weight + neighbor.weight
        if new_path_weight < neighbor.min_path_weight
          neighbor.min_path_weight = new_path_weight
          neighbor.min_path = node.min_path + [ neighbor.weight ]
          updates << neighbor_key
        end
      end
    end

    @improved_path_nodes = updates
  end

end

g = EulerGraph.new( )

pf = PathFinder.new( g, g.origin.key, g.terminal.key )
puts pf.find_min_path


