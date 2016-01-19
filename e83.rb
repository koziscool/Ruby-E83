

class PointInfo

  attr_reader  :row, :col
  attr_accessor @weight, @min_path_weight, @improved_path, @min_path
  
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

  def print_min_path

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
      if in_bounds( new_row, new_col)
        neighbors << [new_row, new_col]
      end
    end
  end

  def in_bounds?
    new_row >= 0 && new_row < width && new_col >= 0 && new_col < height
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
