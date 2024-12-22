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

def process_number(num)
  seq = [nil, nil, nil, nil]
  seqmap = Hash.new(0)

  number = num
  i = 0

  while i < 2000
    new_number = make_random_num(number)
    seq.push((new_number % 10) - (number % 10))
    seq.shift
    seqmap[seq.to_s] = (new_number % 10) if !seqmap.key?(seq.to_s) && i > 2

    number = new_number
    i += 1
  end

  seqmap
end

def best_sequence(file)
  input = File.read(File.join(File.dirname(__FILE__), file))

  sequence_map = Hash.new(0)
  seqmap = nil

  input.lines.each_with_index do |line, lnum|
    print "\rProcessing line: #{lnum}"
    num = line.strip.to_i
    seqmap = process_number(num)
    sequence_map.merge!(seqmap) { |_k, a, b| a + b }
  end

  puts ''
  sequence_map.values.max
end

puts best_sequence('day22-input.txt')
