def multiply_from_corrupted_memory_part_two
  input = File.read('day3-input.txt')

  filtered_input = remove_between_dont_and_do(input)

  matches = filtered_input.scan(/mul\(\d{1,3},\d{1,3}\)/)

  sum = 0

  matches.each do |cmd|
    numbers = cmd[4..-2].split(',').map(&:to_i)
    sum += numbers[0] * numbers[1]
  end

  sum
end

# @param input [String] input string of corrupted memory
# @return [String] input with all sections marked for skipping removed
def remove_between_dont_and_do(input)
  result = input.dup

  while (dont_index = result.index("don't()"))
    do_index = result.index("do()", dont_index)

    if do_index
      result.slice!(dont_index..do_index + "do()".length - 1)
    else
      result.slice!(dont_index..-1)
    end
  end

  result
end

puts multiply_from_corrupted_memory_part_two
