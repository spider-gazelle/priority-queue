require "spec"
require "../src/priority-queue/max_heap"

describe Priority::Heap do
  describe "(empty)" do
    it "should let you insert and remove one item" do
      heap = Priority::MaxHeap(Int32, Int32).new
      heap.size.should eq(0)

      heap.push(1)
      heap.size.should eq(1)

      heap.pop
      heap.size.should eq(0)
    end

    it "should merge another heap" do
      heap = Priority::MaxHeap(Int32, Int32).new
      heap2 = Priority::MaxHeap(Int32, Int32).new
      heap2.push(3)
      heap2.push(4)
      heap2.push(5)
      heap2.push(5)

      heap.merge! heap2
      heap2.size.should eq(0)
      heap.size.should eq(4)
      heap.pop.should eq(5)
      heap.pop.should eq(5)
      heap.pop.should eq(4)
      heap.pop.should eq(3)
      heap.size.should eq(0)
    end
  end

  describe "(non-empty)" do
    it "should display the correct size" do
      heap = Priority::MaxHeap(Int32, Int32).new
      random_array = [] of Int32
      num_items = 100
      num_items.times { random_array << rand(num_items) }
      random_array.each { |i| heap.push(i) }

      heap.size.should eq(num_items)

      ordered = [] of Int32
      while !heap.empty?
        ordered << heap.pop.not_nil!
      end
      ordered.should eq(random_array.sort.reverse)
    end
  end
end
