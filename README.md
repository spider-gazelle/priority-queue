# Crystal Lang Priority Queue

[![Build Status](https://travis-ci.org/spider-gazelle/priority-queue.svg?branch=master)](https://travis-ci.org/spider-gazelle/priority-queue)


Usage
=====

Simple priority queue.

* Higher numbers `pop` first
* lower numbers `shift` first
* always insert using `push` or `<<` to maintain validity

```crystal

require 'priority-queue'

queue = Priority::Queue(String).new
queue.push 10, "Insert 1"
queue.push 20, "Insert 2"

queue.pop.value # => "Insert 2"
queue.pop.value # => "Insert 1"

```

A named priority queue where newer items with the same name replace existing items. The highest of the two priorities is inherited by the new item.

```crystal

require 'priority-queue'

queue = Priority::NamedQueue(String).new
queue.push 20, "Insert 1", :named
queue.push 20, "Insert 2"
queue.push 10, "Insert 3", :named

queue.size # => 2

queue.pop.value # => "Insert 3"
queue.pop.value # => "Insert 2"

```
