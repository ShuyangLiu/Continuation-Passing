# A simple implementation of binary tree for question 03 part b
class Node
  attr_accessor :data, :left_child, :right_child
  def initialize (d)
    @data = d
  end
  def add(node)
    if self.left_child == nil
      self.left_child = node
    elsif self.right_child == nil
      self.right_child = node
    else
      self.left_child.add(node)
    end
  end
end

class MyBinaryTree
  attr_accessor :root
  def initialize
    @root = nil
  end
  def add_node(data)
    node = Node.new(data)
    if @root == nil
      @root = node
    else
      @root.add(node)
    end
  end
end



