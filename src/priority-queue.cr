require "bisect"

module Priority
  class Item(V)
    include Comparable(Item(V))

    def initialize(@priority : Int32, @value : V, name = nil)
      @name = name.to_s if name
    end

    @name : String?
    getter :value, :name
    property :priority

    # required for comparable
    def <=>(item)
      @priority <=> item.priority
    end
  end

  class Queue(V)
    def initialize
      @array = [] of Item(V)
    end

    def push(priority : Int32, value : V, name = nil)
      item = Item(V).new(priority, value, name)
      push(item)
    end

    def push(item : Item(V))
      Bisect.insort_left(@array, item)
    end

    def push(*items : Item(V))
      items.each { |item| push(item) }
    end

    def <<(item : Item(V))
      push(item)
    end

    forward_missing_to @array
  end
end

require "./priority-queue/named_queue"
