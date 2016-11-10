require_relative 'simple_enum.rb'
require_relative 'binary_tree'
##########################
# CSC 253 Assignment 6
# Shuyang Liu
# Due: 11/11/2016
##########################
# Question 03
##########################
# - Part A -

# a simple recursive factorial function
def simple_factorial(num)
  if num == 1
    1
  else
    num * simple_factorial(num - 1)
  end
end

# a tail-recursive version of factorial function passing a continuation as parameter
def tail_recursive_factorial(n)
    callcc{ |c|
      helper(n,c,1)
    }
end

def helper (n, cc, res)
  if n <= 0
    cc.call(res)
  else
    helper(n-1, cc,res*n)
  end
end

# - Part B -
# a simple recursive function counting the number of nodes in a binary tree
def total_node_number(tree)
  if tree.root == nil
    0
  else
    left_tree = MyBinaryTree.new
    left_tree.root = tree.root.left_child
    right_tree = MyBinaryTree.new
    right_tree.root = tree.root.right_child
    1+total_node_number(left_tree)+total_node_number(right_tree)
  end
end

# a tail-recursive function using callcc counting the number of nodes in a binary tree



##########################
# TESTS
##########################
# - Part A -
def test_factorial
  raise "#{__method__} error" if (simple_factorial(10) != tail_recursive_factorial(10))
  puts "#{__method__} passed"
end

test_factorial

# - Part B -
def test_total_node_number
  b = MyBinaryTree.new
  100.times do |i|
    b.add_node(i)
  end
  raise "#{__method__} error" if total_node_number(b) != 100
  puts "#{__method__} passed"
end

test_total_node_number





