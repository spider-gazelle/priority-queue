require "../priority-queue"

class Priority::NamedQueue(V) < Priority::Queue(V)
  @named_items = {} of String => Item(V)
  getter :named_items

  def push(item : Item(V))
    if name = item.name
      if exists = @named_items[name]?
        index = bsearch_index { |existing, _index| existing.name == item.name }
        if index
          if item.priority > exists.priority
            delete_at(index)
            Bisect.insort_left(@array, item)
          else
            item.priority = exists.priority
            self[index] = item
          end
        else
          Bisect.insort_left(@array, item)
        end
      else
        Bisect.insort_left(@array, item)
      end
      @named_items[name] = item
    else
      Bisect.insort_left(@array, item)
    end
  end

  def pop
    item = @array.pop
    @named_items.delete(item.name) if item.name
    item
  end

  def pop(n : Int)
    items = @array.pop(n)
    items.each { |item| @named_items.delete(item.name) if item.name }
    items
  end

  def shift
    item = @array.shift
    @named_items.delete(item.name) if item.name
    item
  end

  def shift(n : Int)
    items = @array.shift(n)
    items.each { |item| @named_items.delete(item.name) if item.name }
    items
  end
end
