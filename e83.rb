

class PointInfo

  attr_reader  :row, :col
  attr_accessor :weight, :min_path_weight, :improved_path, :min_path

  def initialize( row, col )
    @row = row
    @col = col
    @weight = 0
    @min_path_weight = 100000000
    @improved_path = false
    @min_path = []
  end

  def to_s
    "row: #{@row}  col:#{@col} weight: #{@weight}  min path weight: #{@min_path_weight}"
  end

  def min_path_string
    ret_string = "[ "
    @min_path.each do | point |
      ret_string = ret_string + "(#{point[0]}, #{point[1]}) " 
    end
    ret_string = ret_string + " ]"
    ret_string
  end
end

class Node
  attr_accessor :info, :neighbors
  def initialize( info )
    @info = info
    @neighbors = []
  end
end

class Graph
  GRAPH_NEIGHBOR_DELTA = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]

  attr_reader :width, :height
  attr_accessor :nodes

  def initialize( width, height )
    # nodes is a hash indexed by (row, col) pair
    @width = width
    @height = height

    @nodes = {}
    (0...width).each do | x |
      (0...height).each do | y |
        point = PointInfo.new( x, y )
        node = Node.new( point )
        build_neighbors( node )
        @nodes[ [x, y] ] = node
      end
    end
  end

  def build_neighbors( node )
    neighbors = []
    GRAPH_NEIGHBOR_DELTA.each do | delta |
      new_row, new_col = node.info.row + delta[0], node.info.col + delta[1]
      if in_bounds?( new_row, new_col)
        neighbors << [new_row, new_col]
      end
    end
  end

  def in_bounds?( row, col)
    row >= 0 && row < width && col >= 0 && col < height
  end

  def build_euler_graph
    f = File.open('p081_matrix.txt')
    lines = f.read().split("\n")
    lines.each_with_index do | line, row |
      weights = line.split(',')
      weights.each_with_index do | w, col |
        @nodes[ [row, col] ].info.weight = w.to_s
      end
    end
  end

end

class PathFinder

  def initialize( graph )
    @graph = graph
  end

  def find_min_path

  end 

end

p = PointInfo.new(3, 4)
puts p

g = Graph.new( 80, 80 )
g.build_euler_graph

