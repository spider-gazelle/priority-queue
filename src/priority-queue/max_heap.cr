require "./heap"

# A MaxHeap is a heap where the items are returned in descending order of key value.
class Priority::MaxHeap(K, V) < Priority::Heap(K, V)
  # call-seq:
  #     MaxHeap.new(ary) -> new_heap
  #
  # Creates a new MaxHeap with an optional array parameter of items to insert into the heap.
  # A MaxHeap is created by calling Heap.new { |x, y| (x <=> y) == 1 }, so this is a convenience class.
  #
  #     maxheap = MaxHeap.new([1, 2, 3, 4])
  #     maxheap.pop #=> 4
  #     maxheap.pop #=> 3
  def initialize
    super { |x, y| (x <=> y) == 1 }
  end
end
