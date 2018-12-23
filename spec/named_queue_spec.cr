require "spec"
require "../src/priority-queue"

describe Priority::NamedQueue do
  it "should display the correct size and sort correctly" do
    queue = Priority::NamedQueue(Int32).new
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

  it "should replace items of the same name" do
    queue = Priority::NamedQueue(String).new
    queue.push 11, "Test1", :named
    queue.push 11, "Test2"
    queue.push 10, "Test4", :named
    queue.push 11, "Test3"

    queue.size.should eq(3)
    queue.named_items.size.should eq(1)

    # Test 4 priority was upgraded
    queue.pop.value.should eq("Test4")
    queue.pop.value.should eq("Test2")
    queue.pop.value.should eq("Test3")

    queue.size.should eq(0)
    queue.named_items.size.should eq(0)

    queue.push 11, "Test1"
    queue.push 11, "Test2", :named
    queue.push 11, "Test3"
    queue.push 12, "Test4", :named

    queue.size.should eq(3)
    queue.named_items.size.should eq(1)

    # Test 2 was removed from the queue and test 4 replaced it
    queue.pop.value.should eq("Test4")
    queue.pop.value.should eq("Test1")
    queue.pop.value.should eq("Test3")

    queue.size.should eq(0)
    queue.named_items.size.should eq(0)
  end
end
