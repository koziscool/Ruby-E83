
require './graph.rb'

class EulerGraph < GraphWithVertexWeights
  GRAPH_NEIGHBOR_DELTA = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]

  attr_reader :width, :height, :origin, :terminal
  attr_accessor :nodes

  def initialize
    super
    build_euler_graph
  end

  def build_neighbors( node )
    neighbors = []
    GRAPH_NEIGHBOR_DELTA.each do | delta |
      new_row, new_col = node.key[0] + delta[0], node.key[1] + delta[1]
      if in_bounds?( new_row, new_col)
        neighbors << [new_row, new_col]
      end
    end
    node.neighbors = neighbors
  end

  def in_bounds?( row, col)
    row >= 0 && row < width && col >= 0 && col < height
  end

  def build_euler_graph
    @width = 80
    @height = 80

    (0...width).each do | x |
      (0...height).each do | y |
        key = [x, y]
        @nodes[ key ] = VertexWithWeight.new( key, [], 0 )
        build_neighbors( @nodes[ key ])
      end
    end

    f = File.open('p081_matrix.txt')
    lines = f.read().split("\n")
    lines.each_with_index do | line, row |
      weights = line.split(',')
      weights.each_with_index do | w, col |
        @nodes[ [row, col] ].weight = w.to_i
      end
    end

    @origin = @nodes[ [0,0] ]
    @terminal = @nodes[ [79,79] ]
  end

end
