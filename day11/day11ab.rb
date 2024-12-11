def count_stones(blinks)
  input = File.read('day11-input.txt').strip.split.map(&:to_i)
  stone_count = Hash.new(0)
  input.each { |n| stone_count[n] += 1 }

  blinks.times do
    stone_count = blink_stones(stone_count)
  end

  stone_count.each_value.sum
end

def blink_stones(stone_count)
  new_stone_count = Hash.new(0)

  stone_count.each do |stone, count|
    blink_single_stone(stone).each do |new_stone|
      new_stone_count[new_stone] += count
    end
  end

  new_stone_count
end

def blink_single_stone(stone)
  if stone.zero?
    [stone + 1]
  elsif stone.digits.length.even?
    [stone.to_s[..stone.digits.length / 2 - 1].to_i, stone.to_s[stone.digits.length / 2..].to_i]
  else
    [stone * 2024]
  end
end

puts "Part 1: #{count_stones(25)}"
puts "Part 2: #{count_stones(75)}"
