# Based on https://github.com/kanwei/algorithms/blob/master/lib/containers/heap.rb
# NOTE:: methods such as delete don't work, here or in the ruby version
# Most other functionality works, left here mainly for anyone who wants to use
# this data structure. This code is not used in the priority queue implementation

class Priority::Heap(K, V)
  # call-seq:
  #     size -> int
  #
  # Return the number of elements in the heap.
  def size : Int32
    @size
  end

  getter :stored

  def next_node
    @next
  end

  # call-seq:
  #     Heap.new(optional_array) { |x, y| optional_comparison_fn } -> new_heap
  #
  # If an optional array is passed, the entries in the array are inserted into the heap with
  # equal key and value fields. Also, an optional block can be passed to define the function
  # that maintains heap property. For example, a min-heap can be created with:
  #
  #     minheap = Heap.new { |x, y| (x <=> y) == -1 }
  #     minheap.push(6)
  #     minheap.push(10)
  #     minheap.pop #=> 6
  #
  # Thus, smaller elements will be parent nodes. The heap defaults to a min-heap if no block
  # is given.
  def initialize
    @compare_fn = ->(x : K, y : K) { (x <=> y) == -1 }
    @next = nil
    @size = 0
    @stored = {} of K => Array(Node(K, V))
  end

  def initialize(&@compare_fn : Proc(K, K, Bool))
    @next = nil
    @size = 0
    @stored = {} of K => Array(Node(K, V))
  end

  @next : Node(K, V)?
  @stored : Hash(K, Array(Node(K, V)))

  # call-seq:
  #     push(key, value) -> value
  #     push(value) -> value
  #
  # Inserts an item with a given key into the heap. If only one parameter is given,
  # the key is set to the value.
  #
  # Complexity: O(1)
  #
  #     heap = MinHeap.new
  #     heap.push(1, "Cat")
  #     heap.push(2)
  #     heap.pop #=> "Cat"
  #     heap.pop #=> 2
  def push(key : K, value : V = key)
    raise "Heap keys must not be nil." unless key
    node = Node.new(key, value)
    # Add new node to the left of the @next node
    if lnext = @next
      node.right = lnext
      node.left = lnext.left
      node.left.right = node
      lnext.left = node
      if @compare_fn.call key, lnext.key
        @next = node
      end
    else
      @next = node
    end
    @size += 1

    array = @stored[key]? || (@stored[key] = [] of Node(K, V))
    array << node
    value
  end

  def <<(key)
    push(key)
  end

  # call-seq:
  #     key?(key) -> true or false
  #
  # Returns true if heap contains the key.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.key?(2) #=> true
  #     minheap.key?(4) #=> false
  def key?(key)
    store = @stored[key]?
    store && !store.empty?
  end

  # call-seq:
  #     next -> value
  #     next -> nil
  #
  # Returns the value of the next item in heap order, but does not remove it.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.next #=> 1
  #     minheap.size #=> 2
  def next
    lnext = @next
    lnext && lnext.value
  end

  # call-seq:
  #     next_key -> key
  #     next_key -> nil
  #
  # Returns the key associated with the next item in heap order, but does not remove the value.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new
  #     minheap.push(1, :a)
  #     minheap.next_key #=> 1
  #
  def next_key
    @next && @next.key
  end

  # call-seq:
  #     clear -> nil
  #
  # Removes all elements from the heap, destructively.
  #
  # Complexity: O(1)
  #
  def clear
    @next = nil
    @size = 0
    @stored = {} of K => Array(Node(K, V))
    nil
  end

  # call-seq:
  #     empty? -> true or false
  #
  # Returns true if the heap is empty, false otherwise.
  def empty?
    @next.nil?
  end

  # call-seq:
  #     merge!(otherheap) -> merged_heap
  #
  # Does a shallow merge of all the nodes in the other heap and clears the other
  # heap
  #
  # Complexity: O(1)
  #
  #     heap = MinHeap.new([5, 6, 7, 8])
  #     otherheap = MinHeap.new([1, 2, 3, 4])
  #     heap.merge!(otherheap)
  #     heap.size #=> 8
  #     heap.pop #=> 1
  def merge!(otherheap)
    other_root = otherheap.next_node
    if other_root
      @stored = @stored.merge(otherheap.stored) { |_key, a, b| a + b }

      # Insert othernode's @next node to the left of current @next
      if lnext = @next
        left = lnext.left
        left.right = other_root if left
        left = other_root.left
        other_root.left = lnext.left
        if left
          left.right = lnext
          lnext.left = left
        end
        @next = other_root if @compare_fn.call(other_root.key, lnext.key)
      else
        @next = other_root
      end
    end
    @size += otherheap.size
    otherheap.clear
    @size
  end

  # call-seq:
  #     pop -> value
  #     pop -> nil
  #
  # Returns the value of the next item in heap order and removes it from the heap.
  #
  # Complexity: O(1)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.pop #=> 1
  #     minheap.size #=> 1
  def pop
    return nil unless @next
    lnext = @next.not_nil!
    popped = lnext
    if @size == 1 && popped
      clear
      return popped.value
    end
    # Merge the popped's children into root node

    if child = lnext.child
      child.parent = nil

      # get rid of parent
      sibling = child.right
      while sibling != lnext.child
        sibling.parent = nil
        sibling = sibling.right
      end

      # Merge the children into the root. If @next is the only root node, make its child the @next node
      if lnext.right == lnext
        lnext = @next = lnext.child
      else
        next_right = lnext.right.not_nil!
        next_left = lnext.left.not_nil!
        current_child = lnext.child.not_nil!
        next_right.left = current_child
        next_left.right = current_child.right
        current_child.right.left = next_left
        current_child.right = next_right
        @next = lnext.right
      end
    else
      lnext.left.right = lnext.right
      lnext.right.left = lnext.left
      @next = lnext.right
    end
    consolidate

    store = @stored[popped.key]
    result = store.delete(popped)
    raise "Couldn't delete node from stored nodes hash\n#{@stored.inspect}\n#{popped.inspect}" unless result

    @size -= 1
    popped.value
  end

  def next!
    pop
  end

  # call-seq:
  #     change_key(key, new_key) -> [new_key, value]
  #     change_key(key, new_key) -> nil
  #
  # Changes the key from one to another. Doing so must not violate the heap property or
  # an exception will be raised. If the key is found, an array containing the new key and
  # value pair is returned, otherwise nil is returned.
  #
  # In the case of duplicate keys, an arbitrary key is changed. This will be investigated
  # more in the future.
  #
  # Complexity: amortized O(1)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.change_key(2, 3) #=> raise error since we can't increase the value in a min-heap
  #     minheap.change_key(2, 0) #=> [0, 2]
  #     minheap.pop #=> 2
  #     minheap.pop #=> 1
  def change_key(key, new_key, delete = false)
    store = @stored[key]?
    return unless store
    return if store.empty? || (key == new_key)

    # Must maintain heap property
    raise "Changing this key would not maintain heap property!" unless (delete || new_key && @compare_fn.call(new_key, key))
    node = store.shift
    if node
      if new_key
        node.key = new_key
        new_store = @stored[new_key]? || (@stored[new_key] = [] of Node(K, V))
        new_store << node
        @stored[new_key] = new_store
      end
      parent = node.parent
      if parent
        # if heap property is violated
        if delete || new_key && @compare_fn.call(new_key, parent.key)
          cut(node, parent)
          cascading_cut(parent)
        end
      end
      lnext = @next
      @next = node if delete || lnext && @compare_fn.call(node.key, lnext.key)
      return [node.key, node.value]
    end
    nil
  end

  # call-seq:
  #     delete(key) -> value
  #     delete(key) -> nil
  #
  # Deletes the item with associated key and returns it. nil is returned if the key
  # is not found. In the case of nodes with duplicate keys, an arbitrary one is deleted.
  #
  # Complexity: amortized O(log n)
  #
  #     minheap = MinHeap.new([1, 2])
  #     minheap.delete(1) #=> 1
  #     minheap.size #=> 1
  def delete(key)
    pop if change_key(key, nil, true)
  end

  # Node class used internally
  class Node(K, V) # :nodoc:
    property :parent, :child, :key, :value, :degree, :marked
    setter :left, :right

    @right : Node(K, V)?
    @left : Node(K, V)?
    @child : Node(K, V)?
    @parent : Node(K, V)?

    def initialize(@key : K, @value : V)
      @degree = 0
      @marked = false
      @right = self
      @left = self
    end

    def marked?
      @marked == true
    end

    def left : Node(K, V)
      l = @left
      l.not_nil!
    end

    def right : Node(K, V)
      r = @right
      r.not_nil!
    end
  end

  # make node a child of a parent node
  private def link_nodes(child, parent)
    # link the child's siblings
    child.left.right = child.right
    child.right.left = child.left

    child.parent = parent

    # if parent doesn't have children, make new child its only child
    if parent.child.nil?
      parent.child = child.right = child.left = child
    else # otherwise insert new child into parent's children list
      current_child = parent.child.not_nil!
      child.left = current_child
      child.right = current_child.right
      current_child.right.left = child
      current_child.right = child
    end
    parent.degree += 1
    child.marked = false
  end

  # Makes sure the structure does not contain nodes in the root list with equal degrees
  private def consolidate
    roots = [] of Node(K, V)
    lnext = @next.not_nil!
    min = lnext
    # find the nodes in the list
    loop do
      roots << lnext
      lnext = lnext.right
      break if lnext == @next
    end
    degrees = [] of Node(K, V)?
    roots.each do |root|
      min = root if @compare_fn.call(root.key, min.key)
      # check if we need to merge
      if !degrees[root.degree]? # no other node with the same degree
        size = degrees.size
        while size <= root.degree
          size += 1
          degrees << nil
        end
        degrees[root.degree] = root
        next
      else # there is another node with the same degree, consolidate them
        degree = root.degree
        while degrees[degree]?
          other_root_with_degree = degrees[degree].not_nil!
          if @compare_fn.call(root.key, other_root_with_degree.key) # determine which node is the parent, which one is the child
            smaller, larger = root, other_root_with_degree
          else
            smaller, larger = other_root_with_degree, root
          end
          link_nodes(larger, smaller)
          size = degrees.size
          while size <= degree
            size += 1
            degrees << nil
          end
          degrees[degree] = nil
          root = smaller
          degree += 1
        end
        size = degrees.size
        while size <= root.degree
          size += 1
          degrees << nil
        end
        degrees[degree] = root
        min = root if min.key == root.key # this fixes a bug with duplicate keys not being in the right order
      end
    end
    @next = min
  end

  private def cascading_cut(node)
    p = node.parent
    if p
      if node.marked?
        cut(node, p)
        cascading_cut(p)
      else
        node.marked = true
      end
    end
  end

  # remove x from y's children and add x to the root list
  private def cut(x : Node(K, V), y : Node(K, V))
    x.left.right = x.right
    x.right.left = x.left
    y.degree -= 1
    if (y.degree == 0)
      y.child = nil
    elsif (y.child == x)
      y.child = x.right
    end
    lnext = @next.not_nil!
    x.right = lnext
    x.left = lnext.left
    lnext.left = x
    x.left.right = x
    x.parent = nil
    x.marked = false
  end
end
