require_relative 'simple_enum.rb'
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




##########################
# TESTS
##########################
# - Part A -
def test_factorial
  raise "#{__method__} error" if (simple_factorial(10) != tail_recursive_factorial(10))
  puts "#{__method__} passed"
end

test_factorial



