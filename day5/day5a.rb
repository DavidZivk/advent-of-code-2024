def sum_mids
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
    mid_sum += get_row_mid(row, cant_be_before)
  end

  mid_sum
end

# @param row [String] a single printing order to be checked for correctness
# @param cant_be_before [Hash] hash of numbers and rules for which numbers it may not preceed
# @return [Integer] middle number value or 0 if ordering is incorrect
def get_row_mid(row, cant_be_before)
  order = row.split(',')
  order.each_with_index do |inspected, idx|
    right_side = order[idx+1..]
    return 0 if right_side.any? {|number| cant_be_before[inspected].include?(number) }
  end

  order[order.length/2].to_i
end

puts sum_mids
