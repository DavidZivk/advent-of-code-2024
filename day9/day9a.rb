def get_checksum
  input = File.read('day9-input.txt').strip

  right = input.length - 1
  left = 0
  pos = 0
  csum = 0

  while left <= right
    if left.even?
      input[left].to_i.times do
        csum += pos * left / 2
        pos += 1
      end

      left += 1
    end

    break if left > right

    [input[left], input[right]].min.to_i.times do
      csum += pos * right / 2
      pos += 1
    end

    # 🍝🧑‍🍳👌
    if input[left].to_i < input[right].to_i
      input[right] = (input[right].to_i - input[left].to_i).to_s
      left += 1
    elsif input[left].to_i > input[right].to_i
      input[left] = (input[left].to_i - input[right].to_i).to_s
      right -= 2
    else
      left += 1
      right -= 2
    end
  end

  csum
end

puts get_checksum
