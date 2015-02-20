require 'pry'

lines = File.open("./small_test.txt", "r").readlines

graph = {}
rev_graph = {}

lines.each do |line|
  split_line = line.split(" ").map(&:to_i)
  graph[split_line[0]] ||= []
  graph[split_line[0]] << split_line[1]

  rev_graph[split_line[1]] ||= []
  rev_graph[split_line[1]] << split_line[0]
end


def dfs_for_finishing_times(graph)
  finishing_times = {}
  explored_nodes = []
  $t = 0

  (1..graph.size).to_a.reverse.each do |key|
    dfs(graph, key, explored_nodes, finishing_times) unless explored_nodes.include?(key)
  end

  finishing_times
end

def dfs(graph, start, explored_nodes, finishing_times)
  explored_nodes << start

  graph[start].each do |child|
    dfs(graph, child, explored_nodes, finishing_times) unless explored_nodes.include?(child)
  end

  $t += 1
  finishing_times[start] = $t
end

def dfs_for_leaders(graph, order)
  leaders = {}
  explored_nodes = []

  s = nil

  binding.pry
  order.each do |item|
    s = item
    dfs_set_leaders(graph, item, leaders, explored_nodes, s) unless explored_nodes.include?(item)
  end

  leaders
end

def dfs_set_leaders(graph, item, leaders, explored_nodes, s)
  explored_nodes << item
  leaders[item] = s

  graph[item].each do |child|
    dfs_set_leaders(graph, child, leaders, explored_nodes, s) unless explored_nodes.include?(child)
  end
end

binding.pry

finishing_times = dfs_for_finishing_times(rev_graph)

order_to_process_for_leaders = finishing_times.sort{|a,b| b[1] <=> a[1]}.map{|pair| pair[0]}

binding.pry

leader_hash = dfs_for_leaders(graph, order_to_process_for_leaders)

binding.pry
