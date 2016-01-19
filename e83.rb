
# require 'pry'

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

  def update( new_path_weight, path )
    @min_path_weight = new_path_weight
    @min_path = path
    @improved_path = true
  end

  def to_s
    "row: #{@row}  col:#{@col} weight: #{@weight}  min path weight: #{@min_path_weight}"
  end

  def min_path_string
    ret_string = "[ "
    @min_path.each do | point |
      ret_string = ret_string + "#{point} " 
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

  attr_reader :width, :height, :origin, :terminal
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
    node.neighbors = neighbors
  end

  def in_bounds?( row, col)
    row >= 0 && row < width && col >= 0 && col < height
  end

  def improved_path_nodes
    @nodes.select  { |key, node| node.info.improved_path }
  end

  def has_improved_path
    @nodes.each do | key, node |
      return true if node.info.improved_path
    end
    false
  end

  def clear_path_improvements
    @nodes.each do | key, node |
      node.info.improved_path = false
    end
  end

  def build_euler_graph
    f = File.open('p081_matrix.txt')
    lines = f.read().split("\n")
    lines.each_with_index do | line, row |
      weights = line.split(',')
      weights.each_with_index do | w, col |
        @nodes[ [row, col] ].info.weight = w.to_i
      end
    end
    @origin = @nodes[ [0,0] ]
    @origin.info.min_path_weight = @origin.info.weight
    @origin.info.min_path << @origin.info.weight
    @origin.info.improved_path = true
    @terminal = @nodes[ [79,79] ]
  end


  def build_test_graph
    matrix = 
    [
    [ 131, 673, 234, 103, 18 ],
    [ 201, 96, 342, 965, 150 ],
    [ 630, 803, 746, 422, 111 ],
    [ 537, 699, 497, 121, 956 ],
    [ 805, 732, 524, 37, 331 ]
    ]

    (0..4).each do |row|
      (0..4).each do |col|
        @nodes[ [row, col] ].info.weight = matrix[row][col]
      end
    end
    @origin = @nodes[ [0,0] ]
    @origin.info.min_path_weight = @origin.info.weight
    @origin.info.min_path << @origin.info.weight
    @origin.info.improved_path = true
    @terminal = @nodes[ [4,4] ]
  end
end

class PathFinder
  def initialize( graph )
    @graph = graph
  end

  def find_min_path
    while @graph.has_improved_path
      main_loop
    end
    # puts @graph.terminal.info.min_path
    @graph.nodes.each do |key, node|
      puts node.info.to_s
      puts node.info.min_path_string
    end
    @graph.terminal.info.min_path_weight
  end 

  def main_loop
    updates = []

    ipn = @graph.improved_path_nodes
    # puts ipn
    ipn.each do | key, node |
      node.neighbors.each do | neighbor_key |
        # print neighbor_key
        neighbor = @graph.nodes[ neighbor_key ]
        new_path_weight = node.info.min_path_weight + neighbor.info.weight
        if node.info.row == 2 && node.info.col == 4 && neighbor_key == [2, 3]
          puts new_path_weight
          puts neighbor.info.min_path_weight
        end
        if new_path_weight < neighbor.info.min_path_weight
          # binding.pry
          new_path = node.info.min_path + [ neighbor.info.weight ]
          update = [ neighbor, new_path_weight, new_path ]
          if node.info.row == 2 && node.info.col == 4 && neighbor_key == [2, 3]
            puts new_path_weight
            puts neighbor.info.min_path_weight
            puts update
          end
          updates << update
          # binding.pry
        end
      end
    end

    @graph.clear_path_improvements

    updates.each do |update|
      # puts update[0]
      update[0].info.update( update[1], update[2] )
      # binding.pry
      # puts update[0]
    end
  end

end

p = PointInfo.new(3, 4)
puts p

g = Graph.new( 5, 5 )
g.build_test_graph
# print g.nodes[ [2, 4] ].neighbors
# print g.nodes[ [79, 1] ].neighbors
# puts
# puts g.terminal

pf = PathFinder.new( g )
puts pf.find_min_path


