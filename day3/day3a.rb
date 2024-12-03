def multiply_from_corrupted_memory
  input = File.read('day3-input.txt')

  matches = input.scan(/mul\(\d{1,3},\d{1,3}\)/)

  sum = 0

  matches.each do |cmd|
    numbers = cmd[4..-2].split(',').map(&:to_i)
    sum += numbers[0] * numbers[1]
  end

  sum
end


puts multiply_from_corrupted_memory
