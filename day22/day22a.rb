def make_random_num(num)
  # Step 1
  num = (num << 6) ^ num
  num &= 0xFFFFFF

  # Step 2
  num = (num >> 5) ^ num
  num &= 0xFFFFFF

  # Step 3
  num = (num << 11) ^ num
  num & 0xFFFFFF
end

def sum_secret_numbers(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  sum = 0

  input.lines.each do |line|
    num = line.strip.to_i
    2000.times do
      num = make_random_num(num)
    end
    sum += num
  end
  sum
end

puts sum_secret_numbers('day22-input.txt')
