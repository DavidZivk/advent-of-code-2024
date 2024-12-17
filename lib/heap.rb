# Simple heap implementation for use in AoC
class Heap
  def initialize(&comparator)
    @heap = []
    @comparator = comparator || proc { |a, b| a < b }
  end

  # Insert a new element into the heap
  def push(val)
    @heap << val
    heapify_up(@heap.size - 1)
  end

  # Remove and return the smallest element from the heap
  def extract_min
    return nil if @heap.empty?

    min = @heap[0]
    if @heap.size == 1
      @heap.pop
    else
      @heap[0] = @heap.pop
      heapify_down(0)
    end
    min
  end

  # Return the smallest element without removing it
  def peek
    @heap[0]
  end

  # Return the number of elements in the heap
  def size
    @heap.size
  end

  # Check if the heap is empty
  def empty?
    @heap.empty?
  end

  # Build a heap from an existing array
  def build_heap(array)
    @heap = array.dup
    parent(@heap.size - 1).downto(0) do |i|
      heapify_down(i)
    end
  end

  # Replace the root with a new value and return the old root
  def replace(val)
    return nil if @heap.empty?

    min = @heap[0]
    @heap[0] = val
    heapify_down(0)
    min
  end

  # Return the internal heap array (for debugging/demo purposes)
  def to_a
    @heap.dup
  end

  # Check if val present in heap
  def include?(val)
    @heap.include?(val)
  end

  private

  # Heapify up from a given index to maintain heap property
  def heapify_up(index)
    return if index.zero?

    parent_index = parent(index)
    return unless @comparator.call(@heap[index], @heap[parent_index])

    swap(index, parent_index)
    heapify_up(parent_index)
  end

  # Heapify down from a given index to maintain heap property
  def heapify_down(index)
    smallest = index
    left = left_child(index)
    right = right_child(index)

    smallest = left if left < @heap.size && @comparator.call(@heap[left], @heap[smallest])

    smallest = right if right < @heap.size && @comparator.call(@heap[right], @heap[smallest])

    return unless smallest != index

    swap(index, smallest)
    heapify_down(smallest)
  end

  # Swap two elements in the heap
  def swap(i, j)
    @heap[i], @heap[j] = @heap[j], @heap[i]
  end

  # Calculate parent index
  def parent(index)
    (index - 1) / 2
  end

  # Calculate left child index
  def left_child(index)
    (2 * index) + 1
  end

  # Calculate right child index
  def right_child(index)
    (2 * index) + 2
  end
end
