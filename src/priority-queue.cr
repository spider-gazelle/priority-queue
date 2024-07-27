require "bisect"

module Priority
  alias Value = Int8 | Int16 | Int32 | Int64 | Int128 | Float32 | Float64

  class Item(V)
    include Comparable(Item(V))

    def initialize(@priority : Value, @value : V, name = nil)
      @name = name.to_s if name
    end

    @name : String?
    getter :value, :name
    property :priority

    # required for comparable
    def <=>(other)
      @priority <=> other.priority
    end
  end

  class Queue(V)
    def initialize
      @array = [] of Item(V)
    end

    def push(priority : Value, value : V, name = nil)
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

    delegate empty?, first, last, first?, last?, size, shift, pop, clear, to: @array
    forward_missing_to @array
  end
end

require "./priority-queue/named_queue"
