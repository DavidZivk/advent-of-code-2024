def get_calibration_sum
  input = File.read(File.join(File.dirname(__FILE__), 'day7-input.txt'))

  calibration_sum = 0

  input.lines.each do |line|
    nums = line.strip.gsub(':', '').split.map(&:to_i)

    result, numbers = nums[0], nums[1..]

    calibration_sum += check_calibration(result, numbers)
  end

  calibration_sum
end


def check_calibration(result, numbers)
  symbols = ['*', '+']

  symbols.repeated_permutation(numbers.length-1).each do |p|
    return result if process_candidate(numbers.zip(p).flatten[..-2]) == result
  end

  0
end


def process_candidate(candidate)
  sum = candidate[0]

  candidate[1..].each_slice(2) do |op|
    sum += op[1] if op[0] == '+'
    sum *= op[1] if op[0] == '*'
  end
  sum
end


puts get_calibration_sum
