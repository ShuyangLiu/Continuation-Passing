require_relative 'simple_enum.rb'
##########################
# CSC 253 Assignment 6
# Shuyang Liu
# Due: 11/11/2016
##########################
# Question 02
##########################

# Infinite Integer - an enumerator that enumerates all the integers starting from 1

$b = Proc.new do |g|
  num = 1 # base case (can be set to 0 if integer starts from 0)
  while true do # an infinite loop so that it can have infinite sequence of integers (Hopefully)
    g.yield num
    num += 1
  end
end

$infinite_integer = SimpleEnum.new(nil,$b)

##########################
# TEST
##########################
def test_infinite_integer
  ary1 = (1..10000).to_a
  ary2 = Array.new
  10000.times do
    ary2 << $infinite_integer.next
  end
  raise "#{__method__} error" if ary1 != ary2
  puts "#{__method__} passed for 1 to 10000"
end

test_infinite_integer


