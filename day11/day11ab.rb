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

def blink_single_stone(rock)
  pebbles = []

  if rock.zero?
    pebbles.append(rock + 1)
  elsif rock.digits.length.even?
    pebbles.append(rock.to_s[..rock.digits.length / 2 - 1].to_i)
    pebbles.append(rock.to_s[rock.digits.length / 2..].to_i)
  else
    pebbles.append(rock * 2024)
  end

  pebbles
end

puts "Part 1: #{count_stones(25)}"
puts "Part 2: #{count_stones(75)}"
