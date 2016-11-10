require 'continuation'
##########################
# CSC 253 Assignment 6
# Shuyang Liu
# Due: 11/11/2016
##########################
# Question 01
##########################

class SimpleEnum
  include Enumerable
  attr_accessor :queue, :block, :cont_next, :cont_end, :cont_yield, :counter
  def initialize(enum = nil,b = nil)
    if enum != nil
      @block = proc { |g|
        enum.each { |x| g.yield x }
      }
    elsif b != nil
      @block = b
    else
      raise "#{__method__} error: should either pass in a enumerable object or a code block, none found"
    end
    @counter = 0
    @queue = []
    @cont_next = @cont_yield = @cont_end = nil
    if (@cont_next = callcc { |c| c })
      @block.call(self)
      @cont_end.call if @cont_end != nil # for catching the end point
    end
  end

  def yield(value)
    if (@cont_yield = callcc { |c| c })
      @queue << value
      @cont_next.call if @cont_next != nil
    end
  end

  def next
    @cont_end = callcc{|c| c}
    raise StopIteration if @queue == []
    if (@cont_next = callcc { |c| c })
      @cont_yield.call if @cont_yield != nil
    end
    @counter += 1
    @queue.shift
  end

  def next?
    !(@queue.length == 0)
  end

  def back_to_beginning # helper function for going back to the beginning
    initialize(nil,@block)
  end

  def with_index(offset = 0)
    # return a new enumerator whose next() call returns a pair [elem, index],
    # where the index starts from the optional offset
    index = self.counter

    self.back_to_beginning

    offset.times do |i|
      self.next
    end
    ary = Array.new
    while self.next? do
      ary << [self.next ,offset]
      offset += 1
    end

    # Restore previous state
    self.back_to_beginning

    index.times do |i|
      self.next
    end

    SimpleEnum.new(ary)
  end
  def each
    self.back_to_beginning
    # taken a block as before in your previous projects
    while self.next? do
      yield self.next
    end
  end
end

##########################
# UNIT TESTS
##########################
def test_initialize
  g = SimpleEnum.new([1,2,3])
  raise "#{__method__} error" if ((g.block == nil) ||
                                  (g.queue == []) ||
                                  (g.cont_next != nil) ||
                                  (g.cont_yield == nil) ||
                                  (g.cont_end != nil))
  puts "#{__method__} passed"
end

def test_yield
  g = SimpleEnum.new([1,2,3])
  if (g.cont_next = callcc{|c| c})
    g.yield(4)
  end
  raise "#{__method__} error" if ((g.queue.nil?)||(g.queue != [1,4]))
  puts "#{__method__} passed"
end

def test_next
  g = SimpleEnum.new([1,2,3])
  raise "#{__method__} error" if g.next != 1
  raise "#{__method__} error" if g.next != 2
  raise "#{__method__} error" if g.next != 3
  begin
    g.next
  rescue Exception => e
    raise "#{__method__} error" if e.to_s != "StopIteration"
  end
  puts "#{__method__} passed"
end

def test_next?
  g = SimpleEnum.new([1,2,3])
  raise "#{__method__} error" unless g.next?
  g.next
  raise "#{__method__} error" unless g.next?
  g.next
  raise "#{__method__} error" unless g.next?
  g.next
  raise "#{__method__} error" if g.next?

  puts "#{__method__} passed"
end

def test_with_index
  g = SimpleEnum.new([1,2,3])
  e1 = g.with_index
  raise "#{__method__} error" if e1.next != [1,0]
  raise "#{__method__} error" if e1.next != [2,1]
  raise "#{__method__} error" if e1.next != [3,2]

  e2 = g.with_index(1)
  raise "#{__method__} error" if e2.next != [2,1]
  raise "#{__method__} error" if e2.next != [3,2]

  e3 = g.with_index(2)
  raise "#{__method__} error" if e3.next != [3,2]

  puts "#{__method__} passed"
end

def test_each
  g = SimpleEnum.new([1,2,3])
  ary = Array.new
  ary << g.next # 1
  g.each do |e| # should begin from the beginning
    ary << e
  end
  raise "#{__method__} error" if ary != [1,1,2,3]
  puts "#{__method__} passed"
end


test_initialize
test_yield
test_next
test_next?
test_with_index
test_each
