require 'continuation'
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
def factorial(num)
  if num == 1
    1
  else
    num * factorial(num - 1)
  end
end

# a tail-recursive version of factorial function passing a continuation as parameter
def factorial_cps(n)
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

##########################
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
def total_node_number_cps(tree)
  callcc{|cc|
    helper_2(tree.root, cc, 0)
  }
end

def helper_2(node, cc, count)
  if node == nil
    cc.call(count)
  else
    if node.left_child == nil
      if node.right_child == nil
        cc.call(count+1) # left == nil, right == nil
      else
        helper_2(node.right_child,cc,count+1)# left == nil, right != nil
      end
    else
      if node.right_child == nil
        helper_2(node.left_child,cc,count+1)# left != nil, right == nil
      else
        helper_2(node.right_child,cc,callcc{|k| helper_2(node.left_child,k,count+1)})# left != nil, right != nil
      end
    end
  end
end

##########################
# TESTS
##########################
# - Part A -
def test_factorial
  raise "#{__method__} error" if (factorial(10) != factorial_cps(10))
  puts "#{__method__} passed"
end

test_factorial

# - Part B -
def test_total_node_number
  b = MyBinaryTree.new
  100.times do |i|
    b.add_node(i)
  end
  raise "#{__method__} error" if ((total_node_number(b) != total_node_number_cps(b)) ||
                                  (total_node_number(b) != 100))
  puts "#{__method__} passed"
end

test_total_node_number





