def sum_sorted_mids
  input = File.read(File.join(File.dirname(__FILE__), 'day5-input.txt'))

  mid_sum = 0

  rules, orders = input.split("\n\n")

  cant_be_before = Hash.new([])

  rules.split.each do |row|
    left, right = row.split("|")
    if cant_be_before[right].empty?
      cant_be_before[right] = [left]
    else
      cant_be_before[right].append(left)
    end
  end

  orders.split.each do |row|
    mid_sum += sort_and_get_mid(row, cant_be_before)
  end

  mid_sum
end

# @param row [String] a single printing order to be sorted
# @param cant_be_before [Hash] hash of numbers and rules for which numbers it may not preceed
# @return [Integer] middle number of sorted order or 0 if no reordering was required
def sort_and_get_mid(row, cant_be_before)
  swap_made = false
  order = row.split(',')
  order.each_with_index do |_, idx|
    right_side = order[idx+1..]

    violation = right_side.find_index{|num| cant_be_before[order[idx]].include?(num)}

    if violation
      order[idx], order[idx+violation+1] = order[idx+violation+1], order[idx]
      swap_made = true
      redo
    end
  end

  swap_made ? order[order.length/2].to_i : 0
end

puts sum_sorted_mids
