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
            insort_left(item)
          else
            item.priority = exists.priority
            self[index] = item
          end
        else
          insort_left(item)
        end
      else
        insort_left(item)
      end
      @named_items[name] = item
    else
      insort_left(item)
    end
  end

  def pop
    item = super
    @named_items.delete(item.name) if item.name
    item
  end

  def pop(n : Int)
    items = super(n)
    items.each { |item| @named_items.delete(item.name) if item.name }
    items
  end

  def shift
    item = super
    @named_items.delete(item.name) if item.name
    item
  end

  def shift(n : Int)
    items = super(n)
    items.each { |item| @named_items.delete(item.name) if item.name }
    items
  end
end
