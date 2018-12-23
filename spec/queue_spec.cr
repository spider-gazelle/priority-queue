require "spec"
require "../src/priority-queue"

describe Priority::Queue do
  it "should display the correct size and sort correctly" do
    queue = Priority::Queue(Int32).new
    random_array = [] of Int32
    num_items = 100
    num_items.times { random_array << rand(num_items) }
    random_array.each { |i| queue.push(i, i) }

    queue.size.should eq(num_items)

    ordered = [] of Int32
    while !queue.empty?
      ordered << queue.pop.value
    end
    ordered.should eq(random_array.sort.reverse)
  end

  it "should add items of the same priority level in the correct order" do
    queue = Priority::Queue(String).new
    queue.push 11, "Test1"
    queue.push 11, "Test2"
    queue.push 10, "Test4"
    queue.push 11, "Test3"

    queue.size.should eq(4)

    queue.pop.value.should eq("Test1")
    queue.pop.value.should eq("Test2")
    queue.pop.value.should eq("Test3")
    queue.pop.value.should eq("Test4")

    queue.size.should eq(0)
  end
end
