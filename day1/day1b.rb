def similarity_calc
  left_list = []
  right_hash = Hash.new(0)

  File.open('day1a-input.txt', 'r') do |f|
    f.each do |line|
      coords = line.split
      left_list.push(coords[0].to_i)

      num = coords[1].to_i
      right_hash[num] = right_hash[num] + 1
    end
  end

  similarity_score = 0

  left_list.each do |num|
    similarity_score += num * right_hash[num]
  end

  similarity_score
end

puts similarity_calc

