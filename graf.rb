class Graph
  Vertex = Struct.new(:name, :neighbours, :dist, :prev)

  def initialize() # nacitame graf
    @vertices = Hash.new{|h,k| h[k]=Vertex.new(k,[],Float::INFINITY)}
    @edges = {}
    @dijkstra_source = nil
    graf
  end

  def graf ()
    second_part = false # k nacitani grafu nepotrebujeme prvni cast failu
    File.open("blue_airlines.txt").readlines.each do |line|
      second_part = true if line.chomp.empty?
      if second_part && !line.chomp.empty? then
        temp = line.strip.split(",")
        v1 = temp[0]
        v2 = temp[1]
        dist = temp[2].to_i
        @vertices[v1].neighbours << v2
        @vertices[v2].neighbours << v1
        @edges[[v1, v2]] = @edges[[v2, v1]] = dist
      end
    end
  end

  def dijkstra(source)
    return  if @dijkstra_source == source
    q = @vertices.values
    q.each do |v|
      v.dist = Float::INFINITY
      v.prev = nil
    end
    @vertices[source].dist = 0
    until q.empty?
      u = q.min_by {|vertex| vertex.dist}
      break if u.dist == Float::INFINITY
      q.delete(u)
      u.neighbours.each do |v|
        vv = @vertices[v]
        if q.include?(vv)
          alt = u.dist + @edges[[u.name, v]]
          if alt < vv.dist
            vv.dist = alt
            vv.prev = u.name
          end
        end
      end
    end
    @dijkstra_source = source
  end

  def shortest_path(source, target)
    dijkstra(source)
    path = []
    u = target
    while u
      path.unshift(u)
      u = @vertices[u].prev
    end
    return path, @vertices[target].dist
  end

  def to_s
    "#<%s vertices=%p edges=%p>" % [self.class.name, @vertices.values, @edges]
  end
end

g = Graph.new

start, stop = gets().strip, gets().strip
path, dist = g.shortest_path(start, stop)
puts "\nshortest path from #{start} to #{stop} has cost #{dist}:"
puts path.join(" -> ")