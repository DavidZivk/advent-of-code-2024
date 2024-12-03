def distance_calc
  left_list = []
  right_list = []

  File.open('day1-input.txt', 'r') do |f|
    f.each do |line|
      coords = line.split
      left_list.push(coords[0].to_i)
      right_list.push(coords[1].to_i)
    end
  end

  left_list.sort!
  right_list.sort!

  difference_sum = 0

  (0..left_list.length-1).each do |i|
    difference_sum += (right_list[i] - left_list[i]).abs
  end

  difference_sum
end

puts distance_calc
