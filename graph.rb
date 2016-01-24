

VertexWithWeight = Struct.new( :key, :neighbors, :weight )


class GraphWithVertexWeights  
  attr_accessor :nodes
  def initialize
    @nodes = {}  # the values held by @nodes should be 
                 #  VertexWithWeight's
  end
end

